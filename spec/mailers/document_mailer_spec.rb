require "rails_helper"

RSpec.describe DocumentMailer, type: :mailer do
  describe 'expiration_notification' do
    let(:employee) { create(:first_employee) }
    let(:driver_license) { create(:driver_license, employee: employee) }
    let(:vehicle_inspection) { create(:vehicle_inspection, employee: employee) }
    let(:documents) { [driver_license, vehicle_inspection] }
    let(:single_document_mail) { DocumentMailer.expiration_notification(employee, [driver_license]) }
    let(:multiple_documents_mail) { DocumentMailer.expiration_notification(employee, documents) }

    it 'renders the headers for single document' do
      expect(single_document_mail.subject).to eq('書類の有効期限が近づいています')
      expect(single_document_mail.to).to eq([employee.email])
      expect(single_document_mail.from).to eq(['testmail@example.com'])
    end

    it 'renders the headers for multiple documents' do
      expect(multiple_documents_mail.subject).to eq('複数の書類の有効期限が近づいています')
      expect(multiple_documents_mail.to).to eq([employee.email])
      expect(multiple_documents_mail.from).to eq(['testmail@example.com'])
    end

    it 'renders the body' do
      expect(single_document_mail.body.encoded).to match(driver_license.model_name.human)
      expect(multiple_documents_mail.body.encoded).to match(driver_license.model_name.human)
      expect(multiple_documents_mail.body.encoded).to match(vehicle_inspection.model_name.human)
    end
  end
end
