module Uploads
  class VehicleInspectionsController < ApplicationController
    before_action :authenticate_employee!
    before_action :set_vehicle_inspection, only: [:edit, :update]

    def new
      @vehicle_inspection = current_employee.vehicle_inspection
      if @vehicle_inspection.present?
        redirect_to edit_uploads_vehicle_inspection_path(@vehicle_inspection)
      else
        @vehicle_inspection = current_employee.build_vehicle_inspection
      end
    end

    def create
      @vehicle_inspection = current_employee.build_vehicle_inspection(vehicle_inspection_params)
      if @vehicle_inspection.save
        redirect_to new_uploads_compulsory_insurance_path, notice: 'Vehicle inspection was successfully created.'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @vehicle_inspection.update(vehicle_inspection_params)
        redirect_to uploads_documents_path, notice: 'Vehicle inspection information was successfully updated.'
      else
        render :edit
      end
    end

    private

    def set_vehicle_inspection
      @vehicle_inspection = current_employee.vehicle_inspection
    end

    def vehicle_inspection_params
      params.require(:vehicle_inspection).permit(:expiration_date, :photo)
    end
  end
end
