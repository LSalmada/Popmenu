require "rails_helper"

RSpec.describe Api::V1::RestaurantsController, type: :request do
  let!(:restaurant) { create(:restaurant) }
  let(:valid_attributes) { {name: "New Restaurant"} }
  let(:invalid_attributes) { {name: ""} }

  describe "GET /api/v1/restaurants" do
    it "returns a list of restaurants" do
      get "/api/v1/restaurants"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an(Array)
    end
  end

  describe "GET /api/v1/restaurants/:id" do
    context "when the restaurant exists" do
      it "returns the restaurant" do
        get "/api/v1/restaurants/#{restaurant.id}"
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["id"]).to eq(restaurant.id)
      end
    end

    context "when the restaurant does not exist" do
      it "returns not found" do
        get "/api/v1/restaurants/99999"
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Restaurant not found")
      end
    end
  end

  describe "POST /api/v1/restaurants" do
    context "with valid parameters" do
      it "creates a new restaurant" do
        expect {
          post "/api/v1/restaurants", params: {restaurant: valid_attributes}
        }.to change(Restaurant, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a restaurant" do
        post "/api/v1/restaurants", params: {restaurant: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /api/v1/restaurants/:id" do
    context "when the restaurant exists" do
      it "updates the restaurant" do
        put "/api/v1/restaurants/#{restaurant.id}", params: {restaurant: {name: "Updated Name"}}
        expect(response).to have_http_status(:ok)
        expect(restaurant.reload.name).to eq("Updated Name")
      end
    end

    context "with invalid parameters" do
      it "does not update the restaurant" do
        put "/api/v1/restaurants/#{restaurant.id}", params: {restaurant: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/restaurants/:id" do
    it "deletes the restaurant" do
      expect {
        delete "/api/v1/restaurants/#{restaurant.id}"
      }.to change(Restaurant, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
