# app/services/import_service.rb
class ImportService
  class << self
    def process_file(file)
      json_data = JSON.parse(file.read)
      process_json_data(json_data)
    rescue JSON::ParserError => e
      Rails.logger.error("JSON parsing error: #{e.message}")
      {success: false, message: "Error processing JSON file: #{e.message}", logs: []}
    rescue => e
      Rails.logger.error("Import error: #{e.message}")
      {success: false, message: "Error during import: #{e.message}", logs: []}
    end

    private

    def process_json_data(json_data)
      logs = []
      success = true
      total_restaurants = 0

      restaurants_data = json_data["restaurants"] || [json_data]

      ActiveRecord::Base.transaction do
        restaurants_data.each do |restaurant_data|
          process_restaurant(restaurant_data, logs)
          total_restaurants += 1
        end
      end

      {
        success: success,
        message: success ? "Import of #{total_restaurants} restaurant(s) completed successfully" :
                          "Errors occurred during import",
        logs: logs
      }
    rescue => e
      Rails.logger.error("Transaction failed: #{e.message}")
      {success: false, message: "Transaction failure: #{e.message}", logs: logs}
    end

    def process_restaurant(restaurant_data, logs)
      restaurant = find_or_create_restaurant(restaurant_data, logs)

      if restaurant && restaurant_data["menus"].present?
        restaurant_data["menus"].each do |menu_data|
          process_menu(restaurant, menu_data, logs)
        end
      elsif restaurant
        logs << {level: "warning", message: "No menu found for the restaurant '#{restaurant.name}'"}
      end
    end

    def find_or_create_restaurant(json_data, logs)
      restaurant = Restaurant.find_or_initialize_by(name: json_data["name"])
      restaurant.description = json_data["description"] if json_data["description"].present?
      restaurant.address = json_data["address"] if json_data["address"].present?

      if restaurant.save
        action = restaurant.previously_new_record? ? "criado" : "atualizado"
        logs << {level: "info", message: "Restaurant '#{restaurant.name}' #{action} com sucesso"}
      else
        logs << {level: "error", message: "Failed to save restaurant: #{restaurant.errors.full_messages.join(", ")}"}
        raise ActiveRecord::Rollback
      end

      restaurant
    end

    def process_menu(restaurant, menu_data, logs)
      menu = find_or_create_menu(restaurant, menu_data, logs)

      if menu
        items_data = menu_data["menu_items"] || menu_data["dishes"] || []

        if items_data.present?
          items_data.each do |item_data|
            process_menu_item(restaurant, menu, item_data, logs)
          end
        else
          logs << {level: "warning", message: "No items found for menu '#{menu.name}'"}
        end
      end
    end

    def find_or_create_menu(restaurant, menu_data, logs)
      menu = restaurant.menus.find_or_initialize_by(name: menu_data["name"])
      menu.description = menu_data["description"] if menu_data["description"].present?
      menu.available = true

      if menu.save
        action = menu.previously_new_record? ? "created" : "updated"
        logs << {level: "info", message: "Menu '#{menu.name}' #{action} with sucess"}
        menu
      else
        logs << {level: "error", message: "Failed to save menu '#{menu_data["name"]}': #{menu.errors.full_messages.join(", ")}"}
        nil
      end
    end

    def process_menu_item(restaurant, menu, item_data, logs)
      menu_item = find_or_create_base_menu_item(restaurant, item_data, logs)
      if menu_item

        if menu.menu_items.include?(menu_item)
          logs << {level: "info", message: "Item '#{menu_item.name}' already exists in the menu '#{menu.name}'"}
        else
          menu.menu_items << menu_item
          logs << {level: "info", message: "Item '#{menu_item.name}' added to menu '#{menu.name}'"}
        end
      end
    end

    def find_or_create_base_menu_item(restaurant, item_data, logs)
      item_name = item_data["name"].strip

      existing_items = MenuItem.joins(:menus).where(
        menus: {restaurant_id: restaurant.id},
        menu_items: {name: item_name}
      ).distinct

      if existing_items.exists?
        menu_item = existing_items.first
        logs << {level: "info", message: "Item '#{menu_item.name}' already exists in the restaurant"}
      else
        menu_item = MenuItem.new(
          name: item_name,
          description: item_data["description"],
          price: item_data["price"],
          available: true
        )

        if menu_item.save
          logs << {level: "info", message: "Item '#{menu_item.name}' successfully created"}
        else
          logs << {level: "error", message: "Failed to create item '#{item_name}': #{menu_item.errors.full_messages.join(", ")}"}
          return nil
        end
      end

      menu_item
    end
  end
end
