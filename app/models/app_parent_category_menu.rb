class AppParentCategoryMenu < ActiveRecord::Base
    ActiveRecord::Base.establish_connection(:development)
    self.table_name =  'app_parent_category_menu'
    self.primary_key =  'id_app_parent_category_menu'

    has_many :AppRelParentChildMenu 
end
