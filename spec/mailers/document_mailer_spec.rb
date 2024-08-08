require "rails_helper"

RSpec.describe DocumentMailer, type: :mailer do
  describe '有効期限通知' do
    let(:first_deparment) { FactoryBot.create(:department_first) }
    let!(:employee) { FactoryBot.create(:first_employee, department: first_deparment) }
    let(:driver_license) { FactoryBot.create(:driver_license, employee: employee) }
    let(:vehicle_inspection) { FactoryBot.create(:vehicle_inspection, employee: employee) }
    let(:documents) { [driver_license, vehicle_inspection] }
    let(:single_document_mail) { DocumentMailer.expiration_notification(employee, [driver_license]) }
    let(:multiple_documents_mail) { DocumentMailer.expiration_notification(employee, documents) }

    it '一つの書類の有効期限が近い時' do
      expect(single_document_mail.subject).to eq('書類の有効期限が近づいています')
      expect(single_document_mail.to).to eq([employee.email])
      expect(single_document_mail.from).to eq(['testmail@example.com'])
    end

    it '複数の書類の有効期限が近い時' do
      expect(multiple_documents_mail.subject).to eq('複数の書類の有効期限が近づいています')
      expect(multiple_documents_mail.to).to eq([employee.email])
      expect(multiple_documents_mail.from).to eq(['testmail@example.com'])
    end

    it 'メールの中身' do
      expect(single_document_mail.body.encoded).to match(driver_license.model_name.human)
      expect(multiple_documents_mail.body.encoded).to match(driver_license.model_name.human)
      expect(multiple_documents_mail.body.encoded).to match(vehicle_inspection.model_name.human)
    end
  end
end
