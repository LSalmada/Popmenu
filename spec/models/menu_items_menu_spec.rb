require "rails_helper"

RSpec.describe MenuItemsMenu, type: :model do
  describe "associations" do
    it { should belong_to(:menu) }
    it { should belong_to(:menu_item) }
  end

  context "when creating a menu_items_menu" do
    let(:menu) { create(:menu) }
    let(:menu_item) { create(:menu_item) }

    it "is valid with a menu and a menu_item" do
      menu_items_menu = build(:menu_items_menu, menu: menu, menu_item: menu_item)
      expect(menu_items_menu).to be_valid
    end

    it "is invalid without a menu" do
      menu_items_menu = build(:menu_items_menu, menu: nil, menu_item: menu_item)
      expect(menu_items_menu).not_to be_valid
      expect(menu_items_menu.errors[:menu]).to include("must exist")
    end

    it "is invalid without a menu_item" do
      menu_items_menu = build(:menu_items_menu, menu: menu, menu_item: nil)
      expect(menu_items_menu).not_to be_valid
      expect(menu_items_menu.errors[:menu_item]).to include("must exist")
    end
  end
end
