class DriverLicensesController < DocumentsController
  private

  def document_class
    DriverLicense
  end

  def document_name
    '免許証'
  end

  def document_params
    params.require(:driver_license).permit(:expiration_date, :photo)
  end

  def next_path
    new_vehicle_inspection_path
  end

  def next_document_name
    '車検証'
  end
end
