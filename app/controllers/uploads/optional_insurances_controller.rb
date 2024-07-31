module Uploads
  class OptionalInsurancesController < ApplicationController
    before_action :authenticate_employee!
    before_action :set_optional_insurance, only: [:edit, :update]

    def new
      @optional_insurance = current_employee.optional_insurance
      if @optional_insurance.present?
        redirect_to edit_uploads_optional_insurance_path(@optional_insurance)
      else
        @optional_insurance = current_employee.build_optional_insurance
      end
    end

    def create
      if params[:optional_insurance][:skip_submission] == '1'
        redirect_to uploads_documents_path, notice: '任意保険の提出はスキップされました。'
      else
        @optional_insurance = current_employee.build_optional_insurance(optional_insurance_params)
        if @optional_insurance.save
          redirect_to uploads_documents_path, notice: '任意保険が提出されました。'
        else
          render :new
        end
      end
    end

    def edit
    end

    def update
      if @optional_insurance.update(optional_insurance_params)
        redirect_to uploads_documents_path, notice: '任意保険情報が更新されました。'
      else
        render :edit
      end
    end

    private

    def set_optional_insurance
      @optional_insurance = current_employee.optional_insurance
    end

    def optional_insurance_params
      params.require(:optional_insurance).permit(:expiration_date, :photo)
    end
  end
end
