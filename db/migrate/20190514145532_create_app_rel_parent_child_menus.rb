class CreateAppRelParentChildMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :app_rel_parent_child_menus do |t|

      t.timestamps
    end
  end
end
