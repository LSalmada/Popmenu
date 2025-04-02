# spec/factories/menus.rb
FactoryBot.define do
  factory :menu do
    name { Faker::Restaurant.name + " Menu" }
    description { Faker::Restaurant.description }
    available { true }
  end
end

# spec/factories/menu_items.rb
FactoryBot.define do
  factory :menu_item do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    price { Faker::Commerce.price(range: 5.0..30.0) }
    association :menu
  end
end
