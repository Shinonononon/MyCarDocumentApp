module Uploads
  class CompulsoryInsurancesController < ApplicationController
    before_action :authenticate_employee!
    before_action :set_compulsory_insurance, only: [:edit, :update]

    def new
      @compulsory_insurance = current_employee.compulsory_insurance
      if @compulsory_insurance.present?
        redirect_to edit_uploads_compulsory_insurance_path(@compulsory_insurance)
      else
        @compulsory_insurance = current_employee.build_compulsory_insurance
      end
    end

    def create
      @compulsory_insurance = current_employee.build_compulsory_insurance(compulsory_insurance_params)
      if @compulsory_insurance.save
        if current_employee.optional_insurance.nil?
          redirect_to new_uploads_optional_insurance_path, notice: 'Compulsory insurance was successfully created. Please submit your optional insurance.'
        else
          redirect_to uploads_documents_path, notice: 'Compulsory insurance was successfully created.'
        end
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @compulsory_insurance.update(compulsory_insurance_params)
        redirect_to uploads_documents_path, notice: 'Compulsory insurance information was successfully updated.'
      else
        render :edit
      end
    end

    private

    def set_compulsory_insurance
      @compulsory_insurance = current_employee.compulsory_insurance
    end

    def compulsory_insurance_params
      params.require(:compulsory_insurance).permit(:expiration_date, :photo)
    end
  end
end
