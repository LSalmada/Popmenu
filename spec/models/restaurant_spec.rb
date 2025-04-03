require "rails_helper"

RSpec.describe Restaurant, type: :model do
  describe "associations" do
    it { should have_many(:menus).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  context "when creating a restaurant" do
    let!(:existing_restaurant) { create(:restaurant, name: "Restaurant") }

    it "is valid with a unique name" do
      new_restaurant = create(:restaurant, name: "Unique Name")
      expect(new_restaurant).to be_valid
    end

    it "is invalid without a name" do
      restaurant = build(:restaurant, name: nil)
      expect(restaurant).not_to be_valid
      expect(restaurant.errors[:name]).to include("can't be blank")
    end

    it "is invalid with a duplicate name" do
      duplicate_restaurant = build(:restaurant, name: "Restaurant")
      expect(duplicate_restaurant).not_to be_valid
      expect(duplicate_restaurant.errors[:name]).to include("has already been taken")
    end
  end
end
