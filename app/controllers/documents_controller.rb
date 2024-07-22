class DocumentsController < ApplicationController
  before_action :set_document, only: [:edit, :update]

  def index
    @driver_licenses = DriverLicense.where(user: current_user)
    @vehicle_inspections = VehicleInspection.where(user: current_user)
    @compulsory_insurances = CompulsoryInsurance.where(user: current_user)
    @optional_insurances = OptionalInsurance.where(user: current_user)
  end

  def new
    @document = document_class.new
  end

  def create
    @document = document_class.new(document_params)
    @document.user = current_user
    if @document.save
      redirect_to next_path, notice: "#{document_name}が提出されました。次は#{next_document_name}を提出してください。"
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
