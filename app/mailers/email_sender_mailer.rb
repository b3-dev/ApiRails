class EmailSenderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.email_sender_mailer.complaintNewNotification.subject
  #
  def configSettings
    ActionMailer::Base.raise_delivery_errors = true
    ActionMailer::Base.smtp_settings = {
        :address              => "189.254.212.150",
        :port                 => 465,
        :user_name            => "eperez@benedettis.com",
        :password             => "abc123",
        :authentication       => "login",
        :enable_starttls_auto => true
      } 
  end
  
  def complaintNewNotification
    configSettings
    @greeting = "Hi"
   # mail to: "lalo_page@hotmail.com"
    mail(to: "eperez@benedettis.com,lalo_page@hotmail.com", subject: 'Welcome to My Awesome Site')
  end
end
