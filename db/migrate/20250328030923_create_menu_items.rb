class CreateMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.references :menu, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.decimal :price
      t.boolean :available

      t.timestamps
    end
  end
end
