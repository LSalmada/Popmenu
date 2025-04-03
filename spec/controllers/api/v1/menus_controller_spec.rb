require "rails_helper"

RSpec.describe Api::V1::MenusController, type: :request do
  let!(:restaurant) { create(:restaurant) }
  let!(:menu) { create(:menu, restaurant: restaurant) }
  let(:valid_attributes) { {name: "New Menu", description: "Delicious items", available: true} }
  let(:invalid_attributes) { {name: "", description: "", available: nil} }

  describe "GET /api/v1/restaurants/:restaurant_id/menus" do
    it "returns all menus of a restaurant" do
      get "/api/v1/restaurants/#{restaurant.id}/menus"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "GET /api/v1/menus/:id" do
    it "returns a menu by id" do
      get "/api/v1/menus/#{menu.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(menu.id)
    end
  end

  describe "POST /api/v1/restaurants/:restaurant_id/menus" do
    context "with valid attributes" do
      it "creates a new menu" do
        expect {
          post "/api/v1/restaurants/#{restaurant.id}/menus", params: {menu: valid_attributes}
        }.to change(Menu, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid attributes" do
      it "returns errors" do
        post "/api/v1/restaurants/#{restaurant.id}/menus", params: {menu: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /api/v1/menus/:id" do
    it "updates a menu" do
      patch "/api/v1/menus/#{menu.id}", params: {menu: {name: "Updated Name"}}
      expect(response).to have_http_status(:ok)
      expect(menu.reload.name).to eq("Updated Name")
    end
  end

  describe "DELETE /api/v1/menus/:id" do
    it "deletes a menu" do
      expect {
        delete "/api/v1/menus/#{menu.id}"
      }.to change(Menu, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
