module Api
  module V1
    class MenuItemsController < ApplicationController
      before_action :set_menu, only: [:index, :create]
      before_action :set_menu_item, only: [:show, :update, :destroy]

      # GET /api/v1/menus/:menu_id/menu_items
      def index
        @menu_items = @menu.menu_items
        render json: @menu_items
      end

      # GET /api/v1/menu_items/:id
      def show
        render json: @menu_item
      end

      # POST /api/v1/menus/:menu_id/menu_items
      def create
        @menu_item = @menu.menu_items.build(menu_item_params)

        if @menu_item.save
          render json: @menu_item, status: :created
        else
          render json: @menu_item.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/menu_items/:id
      def update
        if @menu_item.update(menu_item_params)
          render json: @menu_item
        else
          render json: @menu_item.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/menu_items/:id
      def destroy
        @menu_item.destroy
        head :no_content
      end

      private

      def set_menu
        @menu = Menu.find(params[:menu_id])
      end

      def set_menu_item
        @menu_item = MenuItem.find(params[:id])
      end

      def menu_item_params
        params.require(:menu_item).permit(:name, :menu_id, :description, :price, :available)
      end
    end
  end
end
