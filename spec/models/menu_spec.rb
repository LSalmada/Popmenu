require "rails_helper"

RSpec.describe Menu, type: :model do
  describe "associations" do
    it { should belong_to(:restaurant) }
    it { should have_many(:menu_items_menus).dependent(:destroy) }
    it { should have_many(:menu_items).through(:menu_items_menus) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "nested attributes" do
    it { should accept_nested_attributes_for(:menu_items) }
  end

  context "when creating a menu" do
    let(:restaurant) { create(:restaurant) }

    it "is valid with a name and associated restaurant" do
      menu = build(:menu, name: "Dinner", restaurant: restaurant)
      expect(menu).to be_valid
    end

    it "is invalid without a name" do
      menu = build(:menu, name: nil, restaurant: restaurant)
      expect(menu).not_to be_valid
      expect(menu.errors[:name]).to include("can't be blank")
    end
  end
end
