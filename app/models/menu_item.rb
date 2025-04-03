class MenuItem < ApplicationRecord
  has_many :menu_items_menus, dependent: :destroy  # ✅ Certo
  has_many :menus, through: :menu_items_menus  # ✅ Certo

  validates :name, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0}
end
