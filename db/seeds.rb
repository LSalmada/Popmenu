# frozen_string_literal: true

puts "🌱 Seeding database..."

# Listas de nomes
restaurant_names = ["Ocean Breeze", "Firewood Grill", "Golden Fork"]
menu_names = ["Lunch Specials", "Dinner Delights"]
menu_item_names = [
  "Grilled Salmon", "Spaghetti Carbonara", "BBQ Ribs", "Mushroom Risotto", "Caesar Salad", "Margherita Pizza",
  "Cheeseburger Deluxe", "Sushi Platter", "Lobster Bisque", "Chocolate Lava Cake", "Tiramisu", "Vanilla Milkshake"
]
menu_item_descriptions = [
  "Freshly prepared with premium ingredients.",
  "A delightful choice for any occasion.",
  "Savor the perfect balance of flavors.",
  "A classic dish with a modern twist.",
  "Rich in taste and crafted to perfection."
]

# Criar restaurantes
restaurant_names.each do |name|
  restaurant = Restaurant.create!(name: name)

  # Criar menus (2 para cada restaurante)
  menus = menu_names.map do |menu_name|
    restaurant.menus.create!(
      name: menu_name,
      description: menu_item_descriptions.sample,
      available: [true, false].sample
    )
  end

  # Criar pelo menos 6 itens no menu e garantir que os mesmos possam estar em ambos os menus do restaurante
  menu_items_sample = menu_item_names.sample(6)
  menu_items_sample.each do |item_name|
    menu_item = MenuItem.find_or_create_by!(name: item_name) do |item|
      item.description = menu_item_descriptions.sample
      item.price = rand(10.0..50.0).round(2)
      item.available = [true, false].sample
    end

    # Adicionar o mesmo item a ambos os menus do restaurante
    menus.each do |menu|
      menu.menu_items << menu_item unless menu.menu_items.exists?(menu_item.id)
    end
  end
end

puts "✅ Seeding completed!"
