# frozen_string_literal: true

namespace :dev do
  desc "Reset the database"
  task reset: :environment do
    system("rails db:drop")
    system("rails db:create")
    system("rails db:migrate")
    system("rails dev:add_data")
  end

  desc "Add categories to the database."
  task add_data: :environment do
    show_spinner("Adding data") { add_data }
  end

  def add_data
    30.times do
      menu = Menu.create!(
        name: Faker::Commerce.vendor,
        description: Faker::Food.description,
        available: [true, false].sample
      )

      rand(3..7).times do
        menu.menu_items.create!(
          name: Faker::Food.dish,
          description: Faker::Food.description,
          price: Faker::Commerce.price(range: 5.0..100.0, as_string: false),
          available: [true, false].sample
        )
      end
    end
  end

  def show_spinner(msg_start, msg_end = "Done!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
