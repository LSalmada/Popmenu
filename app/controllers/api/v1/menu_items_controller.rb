module Api
  module V1
    class MenuItemsController < ApplicationController
      before_action :set_menu
      before_action :set_menu_item, only: [:show, :update, :destroy]

      def index
        @menu_items = @menu.menu_items
        render json: @menu_items
      end

      def show
        render json: @menu_item
      end

      def create
        @menu_item = @menu.menu_items.build(menu_item_params)

        if @menu_item.save
          render json: @menu_item, status: :created
        else
          render json: {errors: @menu_item.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def update
        if @menu_item.update(menu_item_params)
          render json: @menu_item
        else
          render json: {errors: @menu_item.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def destroy
        @menu_item.destroy
        head :no_content
      end

      private

      def set_menu
        @menu = Menu.find(params[:menu_id])
      end

      def set_menu_item
        @menu_item = @menu.menu_items.find(params[:id])
      end

      def menu_item_params
        params.require(:menu_item).permit(:name, :description, :price, :category)
      end
    end
  end
end
