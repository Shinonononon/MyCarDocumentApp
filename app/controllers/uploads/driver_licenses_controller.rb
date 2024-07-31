module Uploads
  class DriverLicensesController < ApplicationController
    before_action :authenticate_employee!
    before_action :set_driver_license, only: [:edit, :update]

    def new
      @driver_license = current_employee.driver_license
      if @driver_license.present?
        redirect_to edit_uploads_driver_license_path(@driver_license)
      else
        @driver_license = current_employee.build_driver_license
      end
    end

    def create
      @driver_license = current_employee.build_driver_license(driver_license_params)
      if @driver_license.save
        if current_employee.vehicle_inspection.nil?
          redirect_to new_uploads_vehicle_inspection_path, notice: '運転免許証が提出されました。次に車検証を提出してください。'
        else
          redirect_to uploads_documents_path, notice: '運転免許証が提出されました。'
        end
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @driver_license.update(driver_license_params)
        redirect_to uploads_documents_path, notice: '運転免許証情報が更新されました。'
      else
        render :edit
      end
    end

    private

    def set_driver_license
      @driver_license = current_employee.driver_license
    end

    def driver_license_params
      params.require(:driver_license).permit(:expiration_date, :photo)
    end
  end
end
