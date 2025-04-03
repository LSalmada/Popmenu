module Api
  module V1
    class MenusController < ApplicationController
      before_action :set_restaurant, only: [:index, :create]
      before_action :set_menu, only: [:show, :update, :destroy]

      # GET /api/v1/restaurants/:restaurant_id/menus
      def index
        menus = @restaurant.menus
        render json: menus, include: [:menu_items]
      end

      # GET /api/v1/menus/:id
      def show
        render json: @menu, include: [:menu_items]
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

      # PATCH/PUT /api/v1/menus/:id
      def update
        if @menu.update(menu_params)
          render json: @menu
        else
          render json: {errors: @menu.errors.full_messages}, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/menus/:id
      def destroy
        @menu.destroy
        head :no_content
      end

      private

      def set_restaurant
        @restaurant = Restaurant.find(params[:restaurant_id])
      rescue ActiveRecord::RecordNotFound
        render json: {error: "Restaurant not found"}, status: :not_found
      end

      def set_menu
        @menu = Menu.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: {error: "Menu not found"}, status: :not_found
      end

      def menu_params
        params.require(:menu).permit(:name, :description, :available, menu_items_attributes: [
          :name, :description, :price, :available
        ])
      end
    end
  end
end
