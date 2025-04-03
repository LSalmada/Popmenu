module Api
  module V1
    class MenuItemsController < ApplicationController
      before_action :set_menu, only: [:create]
      before_action :set_menu_item, only: [:show, :update, :destroy]

      # GET /api/v1/menu_items
      # GET /api/v1/restaurants/:restaurant_id/menus/:menu_id/menu_items
      def index
        if params[:menu_id]
          menu = Menu.find(params[:menu_id])
          @menu_items = menu.menu_items.distinct
        else
          @menu_items = MenuItem.all
        end

        render json: @menu_items
      end

      # GET /api/v1/menu_items/:id
      def show
        render json: @menu_item
      end

      # POST /api/v1/menu_items
      # POST /api/v1/restaurants/:restaurant_id/menus/:menu_id/menu_items
      def create
        @menu_item = MenuItem.new(menu_item_params.except(:menu_id))

        if @menu_item.save
          @menu.menu_items << @menu_item if @menu
          render json: @menu_item, status: :created
        else
          render json: {errors: @menu_item.errors.full_messages}, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/menu_items/:id
      def update
        if @menu_item.update(menu_item_params)
          render json: @menu_item
        else
          render json: {errors: @menu_item.errors.full_messages}, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/menu_items/:id
      def destroy
        @menu_item.destroy
        head :no_content
      end

      private

      def set_menu
        @menu = Menu.find(params[:menu_id]) if params[:menu_id]
      end

      def set_menu_item
        @menu_item = MenuItem.find(params[:id])
      end

      def menu_item_params
        params.require(:menu_item).permit(:name, :description, :price, :available, :menu_id)
      end
    end
  end
end
