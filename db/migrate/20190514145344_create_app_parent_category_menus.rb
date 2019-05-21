class CreateAppParentCategoryMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :app_parent_category_menu, :id_app_parent_category_menus => false do |t|
    
      t.integer :id_app_parent_category_menu, :options => 'PRIMARY KEY'
      t.string :description_category_menu
      t.integer :activated_category_menu
    end
  end
end
