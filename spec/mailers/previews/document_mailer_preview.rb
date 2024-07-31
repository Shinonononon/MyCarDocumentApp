# Preview all emails at http://localhost:3000/rails/mailers/document_mailer_mailer
class DocumentMailerPreview < ActionMailer::Preview
  def expiration_notification
    employee = Employee.first
    documents = DriverLicense.all
    DocumentMailer.expiration_notification(employee, documents)
  end
end
