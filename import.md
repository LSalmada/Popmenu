# Restaurant Data Import

This section describes how to use the restaurant data import functionality that allows you to import restaurant, menu, and menu item data from JSON files into the application.

## JSON Format

The import tool supports JSON files with the following structure:

```json
{
  "restaurants": [
    {
      "name": "Restaurant Name",
      "menus": [
        {
          "name": "Menu Name",
          "menu_items": [
            {
              "name": "Item Name",
              "price": 9.99
            }
          ]
        },
        {
          "name": "Another Menu",
          "dishes": [
            {
              "name": "Another Item",
              "price": 12.99
            }
          ]
        }
      ]
    }
  ]
}
```

The import tool is flexible and supports:
- Both `menu_items` and `dishes` as item collection names
- Special characters in item names
- Multiple restaurants in a single file
- Items with the same name across different restaurants

## Import Methods

There are two ways to import restaurant data:

### 1. Command Line Import

Use the provided rake task:

```bash
# For Bash
rake "import:restaurant_data[path/to/restaurant_data.json]"

# For ZSH (with quotes to escape brackets)
rake "import:restaurant_data[path/to/restaurant_data.json]"

# Alternative approach using environment variable
FILE=path/to/restaurant_data.json rake import:restaurant_data
```

### 2. API Endpoint

The application provides an HTTP endpoint to upload and process JSON files:

```
POST /api/v1/restaurants/import
```

You can use this endpoint with the following cURL command:

```bash
curl -X POST -H "Content-Type: multipart/form-data" \
  -F "file=@path/to/restaurant_data.json" \
  http://localhost:3000/api/v1/restaurants/import
```

Or with Postman:
1. Set the request type to POST
2. Use the URL http://localhost:3000/api/v1/restaurants/import
3. In the "Body" tab, select "form-data"
4. Add a key called "file" and select "File" from the dropdown
5. Choose your JSON file and click "Send"

## Sample File

A sample file is included with the project at:

```
lib/tasks/data/restaurant_data.json
```

You can use this file to test the import functionality:

```bash
rake "import:restaurant_data[lib/tasks/data/restaurant_data.json]"
```

## Import Rules

The import follows these rules:

1. **Restaurant uniqueness**: Restaurants with the same name will be updated rather than duplicated
2. **Menu uniqueness**: Menus with the same name under the same restaurant will be updated
3. **Menu item uniqueness**: Menu items with the same name under the same restaurant will be reused
4. **Cross-restaurant items**: The same item name can exist in different restaurants

## Utility Commands

Clear all imported data:

```bash
rails dev:clean
```

This is useful when testing the import functionality multiple times.

## Logs and Output

After running an import, you'll see detailed logs showing:

- Success/failure status for each operation
- Number of restaurants, menus, and menu items imported
- Any validation errors encountered
- Summary statistics about the import

## Error Handling

The import tool handles various error conditions:

- Invalid JSON formatting
- Missing required fields
- Validation errors on database models
- Duplicate items within the same restaurant
- Special characters in names

In all cases, the import process will provide clear error messages and logs to help diagnose and fix issues.