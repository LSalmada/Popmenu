require "rails_helper"

RSpec.describe ImportService do
  let(:json_data) do
    {
      restaurants: [
        {
          name: "Poppo's Cafe",
          menus: [
            {
              name: "lunch",
              menu_items: [
                {
                  name: "Burger",
                  price: 9
                },
                {
                  name: "Small Salad",
                  price: 5
                }
              ]
            }
          ]
        }
      ]
    }.to_json
  end

  describe ".process_file" do
    let(:file) { instance_double("File", read: json_data) }

    it "imports restaurant data correctly" do
      expect {
        result = ImportService.process_file(file)
        expect(result[:success]).to be true
        expect(result[:logs].size).to be > 0
      }.to change { Restaurant.count }.by(1)
        .and change { Menu.count }.by(1)
        .and change { MenuItem.count }.by(2)
    end

    it "does not duplicate menu items with the same name" do
      ImportService.process_file(file)
      ImportService.process_file(file)

      expect(MenuItem.count).to eq(2)
    end

    it "returns error for invalid JSON" do
      invalid_file = instance_double("File", read: "invalid json")
      result = ImportService.process_file(invalid_file)

      expect(result[:success]).to be false
      expect(result[:message]).to include("Error processing JSON file")
    end
  end
end
