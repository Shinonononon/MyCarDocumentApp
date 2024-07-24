module Uploads
  class VehicleInspectionsController < DocumentsController
    private

    def document_class
      VehicleInspection
    end

    def document_name
      '車検証'
    end

    def document_params
      params.require(:vehicle_inspection).permit(:expiration_date, :photo)
    end

    def next_path
      new_compulsory_insurance_path
    end

    def next_document_name
      '自賠責保険'
    end
  end
end
