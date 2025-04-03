require "rails_helper"

RSpec.describe Api::V1::MenuItemsController, type: :request do
  let!(:restaurant) { create(:restaurant) }
  let!(:menu) { create(:menu, restaurant: restaurant) }
  let!(:menu_item) { create(:menu_item, menus: [menu]) }
  let(:valid_attributes) { {name: "Burger", description: "Delicious beef burger", price: 10.99, available: true} }
  let(:invalid_attributes) { {name: "", description: "", price: nil, available: nil} }

  describe "GET /api/v1/menu_items" do
    it "returns all menu items" do
      get "/api/v1/menu_items"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "POST /api/v1/menu_items" do
    context "with valid attributes" do
      it "creates a menu item without associating it to a menu" do
        expect {
          post "/api/v1/menu_items", params: {menu_item: valid_attributes}
        }.to change(MenuItem, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid attributes" do
      it "returns errors" do
        post "/api/v1/menu_items", params: {menu_item: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /api/v1/menu_items/:id" do
    context "with valid attributes" do
      it "updates a menu item" do
        patch "/api/v1/menu_items/#{menu_item.id}", params: {menu_item: {name: "Updated Burger"}}
        expect(response).to have_http_status(:ok)
        expect(menu_item.reload.name).to eq("Updated Burger")
      end
    end

    context "with invalid attributes" do
      it "does not update a menu item" do
        patch "/api/v1/menu_items/#{menu_item.id}", params: {menu_item: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/menu_item/:id" do
    it "deletes a menu item" do
      expect {
        delete "/api/v1/menu_items/#{menu_item.id}"
      }.to change(MenuItem, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
