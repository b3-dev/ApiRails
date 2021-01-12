# Preview all emails at http://localhost:3000/rails/mailers/email_sender_mailer
class EmailSenderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/email_sender_mailer/complaintNewNotification
  def complaintNewNotification
    EmailSenderMailer.complaintNewNotification
  end

end
