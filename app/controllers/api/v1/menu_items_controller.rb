module Api
  module V1
    class MenuItemsController < ApplicationController
      before_action :set_menu, only: [:create]

      # GET /api/v1/menu_items -> Retorna todos os itens do sistema
      # GET /api/v1/restaurants/:restaurant_id/menus/:menu_id/menu_items -> Retorna itens de um menu específico
      def index
        if params[:menu_id]
          menu = Menu.find(params[:menu_id])
          @menu_items = menu.menu_items.distinct
        else
          @menu_items = MenuItem.all
        end

        render json: @menu_items
      end

      # POST /api/v1/menu_items -> Cria um item sem vinculação a um menu
      # POST /api/v1/restaurants/:restaurant_id/menus/:menu_id/menu_items -> Cria um item e associa ao menu
      def create
        @menu_item = MenuItem.new(menu_item_params.except(:menu_id))

        if @menu_item.save
          @menu.menu_items << @menu_item if @menu
          render json: @menu_item, status: :created
        else
          render json: {errors: @menu_item.errors.full_messages}, status: :unprocessable_entity
        end
      end

      private

      def set_menu
        @menu = Menu.find(params[:menu_id]) if params[:menu_id]
      end

      def menu_item_params
        params.require(:menu_item).permit(:name, :description, :price, :available, :menu_id)
      end
    end
  end
end
