namespace :import do
  desc "Imports restaurant data from a JSON file"
  task :restaurant_data, [:file_path] => :environment do |t, args|
    if args[:file_path].blank?
      puts "ERROR: Specify the file path. Example: rake import:restaurant_data[path/to/restaurant_data.json]"
      next
    end

    unless File.exist?(args[:file_path])
      puts "ERROR: File not found: #{args[:file_path]}"
      next
    end

    begin
      file = File.open(args[:file_path])
      puts "Starting import from #{args[:file_path]}..."
      result = ImportService.process_file(file)

      puts "\n====== IMPORT RESULT ======"
      puts "Status: #{result[:success] ? "SUCCESS ✓" : "FAILURE ✗"}"
      puts "Message: #{result[:message]}"
      puts "\n====== IMPORT LOGS ======"

      result[:logs].each do |log|
        level_symbol = case log[:level]
        when "info" then "✓"
        when "warning" then "⚠️"
        when "error" then "✗"
        else "-"
        end

        puts "[#{level_symbol} #{log[:level].upcase}] #{log[:message]}"
      end

      if result[:success]
        puts "\n====== SUMMARY ======"
        puts "Total restaurants: #{Restaurant.count}"
        puts "Total menus: #{Menu.count}"
        puts "Total unique menu items: #{MenuItem.count}"
        puts "Total menu-item associations: #{MenuItemsMenu.count}"
      end
    rescue => e
      puts "CRITICAL ERROR: #{e.message}"
      puts e.backtrace.join("\n")
    ensure
      file.close if file
    end
  end
end
