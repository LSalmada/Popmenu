FactoryBot.define do
  factory :menu do
    name { Faker::Restaurant.name + " Menu" }
    description { Faker::Restaurant.description }
    available { true }
    restaurant { create(:restaurant) }
  end
end
