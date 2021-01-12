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
  
  def complaintNewNotification(data)
    #mail(:subject => "enter your subject", :bcc => "email@email.com")
    #@bcc = User.all.pluck(:email)
    configSettings
    dataJson =  JSON.parse(data.to_json) #for data to query active record, first pass to json and then convert to objet
    @dataSending = dataJson
    dataAddressList = AppCategoryNotificationsEmailRecipient
    .all.where(activated_category_notifications_email_recipients:1)
    .pluck(:address_notifications_email_recipients)

    mail(to: "eperez@benedettis.com,lalo_page@hotmail.com", bcc:dataAddressList, subject: 'Notificación de incidencia')
  end

  def issueNewNotification(data)
    configSettings
   @dataSending = data
   # mail to: "lalo_page@hotmail.com"
    mail(to: "eperez@benedettis.com,lalo_page@hotmail.com", subject: 'Nueva solicitud de asociado')
  end

  def issueResolveNotification(data)
    configSettings
    @dataSending = data
   # mail to: "lalo_page@hotmail.com"
    mail(to: "eperez@benedettis.com,lalo_page@hotmail.com", subject: 'Respuesta a tu solicitud')
  end
end
