class OptionalInsurancesController < DocumentsController
  private

  def document_class
    OptionalInsurance
  end

  def document_name
    '任意保険'
  end

  def document_params
    params.require(:optional_insurance).permit(:expiration_date, :photo)
  end

  def next_path
    root_path
  end

  def next_document_name
    ''
  end
end
