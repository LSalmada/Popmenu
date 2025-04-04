namespace :dev do
  desc "Clean the database"
  task clean: :environment do
    puts "Cleaning data..."
    MenuItemsMenu.delete_all
    MenuItem.delete_all
    Menu.delete_all
    Restaurant.delete_all
    puts "Database cleaned with sucess"
  end
end
