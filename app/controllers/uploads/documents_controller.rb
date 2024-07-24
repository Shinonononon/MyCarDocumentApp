module Uploads
  class DocumentsController < ApplicationController
    before_action :set_document, only: [:edit, :update]

    def index
      @driver_licenses = DriverLicense.all
      @vehicle_inspections = VehicleInspection.all
      @compulsory_insurances = CompulsoryInsurance.all
      @optional_insurances = OptionalInsurance.all
    end

    def new
      @document = document_class.new
    end

    def create
      @document = document_class.new(document_params)
      if @document.save
        redirect_to next_path, notice: "#{document_name}が提出されました。"
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @document.update(document_params)
        redirect_to root_path, notice: "#{document_name}情報が更新されました。"
      else
        render :edit
      end
    end

    private

    def set_document
      @document = document_class.find(params[:id])
    end

    def document_class
      raise NotImplementedError
    end

    def document_name
      raise NotImplementedError
    end

    def document_params
      raise NotImplementedError
    end

    def next_path
      raise NotImplementedError
    end

    def next_document_name
      raise NotImplementedError
    end
  end
end
