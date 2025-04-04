class Restaurant < ApplicationRecord
  has_many :menu_items, through: :menus
  has_many :menus, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
