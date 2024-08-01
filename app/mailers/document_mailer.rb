class DocumentMailer < ApplicationMailer
  default from: 'testmail@example.com'

  def expiration_notification(employee, documents)
    @employee = employee
    @documents = documents
    subject = documents.size > 1 ? '複数の書類の有効期限が近づいています' : '書類の有効期限が近づいています'
    mail(to: @employee.email, subject: subject)
  end
end
