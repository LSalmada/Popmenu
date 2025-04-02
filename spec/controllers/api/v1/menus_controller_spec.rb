require "rails_helper"

RSpec.describe Api::V1::MenuItemsController, type: :request do
  # Create test data using factories
  let!(:menu) { create(:menu) }
  let!(:menu_items) { create_list(:menu_item, 3, menu: menu) }
  let(:menu_id) { menu.id }
  let(:menu_item_id) { menu_items.first.id }
  let(:valid_attributes) {
    {menu_item: attributes_for(:menu_item)}
  }
  let(:invalid_attributes) { {menu_item: {name: nil, price: -5}} }

  # Tests for GET /api/v1/menus/:menu_id/menu_items
  describe "GET /api/v1/menus/:menu_id/menu_items" do
    before { get "/api/v1/menus/#{menu_id}/menu_items" }

    context "when the menu exists" do
      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

      it "returns all menu items for the menu" do
        expect(JSON.parse(response.body).size).to eq(3)
      end
    end

    context "when the menu does not exist" do
      let(:menu_id) { 0 }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns an error message" do
        expect(response.body).to match(/Couldn't find Menu/)
      end
    end
  end

  # Tests for GET /api/v1/menu_items/:id
  describe "GET /api/v1/menu_items/:id" do
    before { get "/api/v1/menu_items/#{menu_item_id}" }

    context "when the item exists" do
      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

      it "returns the menu item" do
        expect(JSON.parse(response.body)["id"]).to eq(menu_item_id)
      end
    end

    context "when the item does not exist" do
      let(:menu_item_id) { 0 }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns an error message" do
        expect(response.body).to match(/Couldn't find MenuItem/)
      end
    end
  end

  # Tests for POST /api/v1/menus/:menu_id/menu_items
  describe "POST /api/v1/menus/:menu_id/menu_items" do
    context "when the parameters are valid" do
      before { post "/api/v1/menus/#{menu_id}/menu_items", params: valid_attributes }

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end

      it "creates a new menu item" do
        expect(JSON.parse(response.body)["name"]).to eq(valid_attributes[:menu_item][:name])
      end
    end

    context "when the parameters are invalid" do
      before { post "/api/v1/menus/#{menu_id}/menu_items", params: invalid_attributes }

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end

      it "returns a validation error message" do
        expect(response.body).to match(/can't be blank/)
      end
    end

    context "when the menu does not exist" do
      before { post "/api/v1/menus/0/menu_items", params: valid_attributes }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns an error message" do
        expect(response.body).to match(/Couldn't find Menu/)
      end
    end
  end

  # Tests for PUT /api/v1/menu_items/:id
  describe "PUT /api/v1/menu_items/:id" do
    context "when the parameters are valid" do
      let(:update_attributes) { {menu_item: {name: "Updated Item", description: "Updated description"}} }
      before { put "/api/v1/menu_items/#{menu_item_id}", params: update_attributes }

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

      it "updates the menu item" do
        updated_item = MenuItem.find(menu_item_id)
        expect(updated_item.name).to eq("Updated Item")
      end

      it "returns the updated menu item" do
        expect(JSON.parse(response.body)["name"]).to eq("Updated Item")
      end
    end

    context "when the parameters are invalid" do
      before { put "/api/v1/menu_items/#{menu_item_id}", params: invalid_attributes }

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end

      it "returns a validation error message" do
        expect(response.body).to match(/can't be blank/)
      end
    end

    context "when the item does not exist" do
      before { put "/api/v1/menu_items/0", params: valid_attributes }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns an error message" do
        expect(response.body).to match(/Couldn't find MenuItem/)
      end
    end
  end

  # Tests for DELETE /api/v1/menu_items/:id
  describe "DELETE /api/v1/menu_items/:id" do
    context "when the item exists" do
      before { delete "/api/v1/menu_items/#{menu_item_id}" }

      it "returns status code 204" do
        expect(response).to have_http_status(204)
      end

      it "removes the menu item" do
        expect { MenuItem.find(menu_item_id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when the item does not exist" do
      before { delete "/api/v1/menu_items/0" }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns an error message" do
        expect(response.body).to match(/Couldn't find MenuItem/)
      end
    end
  end
end
