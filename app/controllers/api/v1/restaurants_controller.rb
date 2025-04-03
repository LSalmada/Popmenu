module Api
  module V1
    class RestaurantsController < ApplicationController
      before_action :set_restaurant, only: [:show, :update, :destroy]

      def import
        if params[:file].present?
          result = ImportService.process_file(params[:file])
          render json: result, status: result[:success] ? :ok : :unprocessable_entity
        else
          render json: {success: false, message: "Nenhum arquivo fornecido"}, status: :bad_request
        end
      end

      # GET /api/v1/restaurants
      def index
        restaurants = Restaurant.includes(menus: :menu_items).limit(5)
        render json: restaurants.map { |restaurant|
          {
            id: restaurant.id,
            name: restaurant.name,
            menus: restaurant.menus.pluck(:name)
          }
        }
      end

      # GET /api/v1/restaurants/:id
      def show
        render json: @restaurant, include: {menus: {include: :menu_items}}
      end

      # POST /api/v1/restaurants
      def create
        restaurant = Restaurant.new(restaurant_params)
        if restaurant.save
          render json: restaurant, status: :created
        else
          render json: {errors: restaurant.errors.full_messages}, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/restaurants/:id
      def update
        if @restaurant.update(restaurant_params)
          render json: @restaurant
        else
          render json: {errors: @restaurant.errors.full_messages}, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/restaurants/:id
      def destroy
        @restaurant.destroy
        head :no_content
      end

      private

      def set_restaurant
        @restaurant = Restaurant.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: {error: "Restaurant not found"}, status: :not_found
      end

      def restaurant_params
        params.require(:restaurant).permit(:name)
      end
    end
  end
end
