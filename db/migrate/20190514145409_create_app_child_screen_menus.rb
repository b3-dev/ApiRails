class CreateAppChildScreenMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :app_child_screen_menus do |t|

      t.timestamps
    end
  end
end
