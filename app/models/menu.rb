class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_items_menus, dependent: :destroy
  has_many :menu_items, through: :menu_items_menus

  validates :name, presence: true

  accepts_nested_attributes_for :menu_items
end
