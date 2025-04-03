module Api
  module V1
    class MenusController < ApplicationController
      before_action :set_restaurant, only: [:index, :create]

      # GET /api/v1/restaurants/:restaurant_id/menus
      def index
        menus = @restaurant.menus
        render json: menus, include: [:menu_items]
      end

      # POST /api/v1/restaurants/:restaurant_id/menus
      def create
        menu = @restaurant.menus.build(menu_params)

        if menu.save
          render json: menu, status: :created
        else
          render json: {errors: menu.errors.full_messages}, status: :unprocessable_entity
        end
      end

      private

      def set_restaurant
        @restaurant = Restaurant.find(params[:restaurant_id])
      rescue ActiveRecord::RecordNotFound
        render json: {error: "Restaurant not found"}, status: :not_found
      end

      def menu_params
        params.require(:menu).permit(:name, :description, :available)
      end
    end
  end
end
