class AppRelParentChildMenu < ActiveRecord::Base
  ActiveRecord::Base.establish_connection(:development)
  self.table_name = "app_rel_parent_child_menu"
  self.primary_key = "id_app_rel_parent_child_menu"

  belongs_to :AppParentCategoryMenu, :foreign_key => "id_parent_category_menu"
  belongs_to :AppChildScreenMenu, :foreign_key => "id_app_child_screen_menu"
  belongs_to :AuthLevel, :foreign_key => "id_autoridad"
end
