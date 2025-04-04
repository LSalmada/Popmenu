class CreateMenuItemsMenus < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items_menus do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true

      t.timestamps
    end
    add_index :menu_items_menus, [:menu_id, :menu_item_id], unique: true
  end
end
