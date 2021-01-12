class AppCategoryNotificationsEmailRecipient <ActiveRecord::Base
    ActiveRecord::Base.establish_connection(:development)
    self.table_name =  'app_category_notifications_email_recipients'
    self.primary_key =  'id_app_category_notifications_email_recipients'

end
