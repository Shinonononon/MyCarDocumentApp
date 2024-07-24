module Uploads
  class CompulsoryInsurancesController < DocumentsController
    private

    def document_class
      CompulsoryInsurance
    end

    def document_name
      '自賠責保険'
    end

    def document_params
      params.require(:compulsory_insurance).permit(:expiration_date, :photo)
    end

    def next_path
      new_
    end

    def next_document_name
      '任意保険'
    end
  end
end
