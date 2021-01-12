class AppChildScreenMenu <  ActiveRecord::Base
    ActiveRecord::Base.establish_connection(:development)
    self.table_name =  'app_child_screen_menu'
    self.primary_key =  'id_app_child_screen_menu'

    has_many :AppRelParentChildMenu 
end
