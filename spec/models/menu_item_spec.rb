require "rails_helper"

RSpec.describe MenuItem, type: :model do
  describe "associations" do
    it { should have_many(:menu_items_menus).dependent(:destroy) }
    it { should have_many(:menus).through(:menu_items_menus) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end

  context "when creating a menu item" do
    it "is valid with a name and a non-negative price" do
      menu_item = create(:menu_item, name: "Burger", price: 10.50)
      expect(menu_item).to be_valid
    end

    it "is invalid without a name" do
      menu_item = build(:menu_item, name: nil, price: 10.50)
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:name]).to include("can't be blank")
    end

    it "is invalid with a negative price" do
      menu_item = build(:menu_item, name: "Burger", price: -5.00)
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:price]).to include("must be greater than or equal to 0")
    end
  end
end
