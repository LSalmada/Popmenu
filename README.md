# Menu Management System

## Project Overview
This is a Ruby on Rails application for managing restaurant menus, supporting multiple restaurants and menus with unique menu items.

## Setup Instructions

### Prerequisites
- Ruby 3.3.1
- Rails 8.0.2
- PostgreSQL

### Installation Steps
1. Clone the repository
2. Run `bundle install`
3. Configure your database in `config/database.yml`
4. Run database migrations:
   ```
   rails db:create
   rails db:migrate
   ```
5. Start the server:
   ```
   rails server
   ```

## Project Levels

### Level 1: Basics
- Created Menu and MenuItem models
- Established relationships
- Created API endpoints for menus

### Level 2: Multiple Menus
- Added Restaurant model
- Implemented multi-menu support
- Ensured unique MenuItem names per menu

### Level 3: JSON Import
- Will implement JSON import functionality
- Add conversion tool for restaurant_data.json

## Running Tests
```
rails test
```

## Design Considerations
- Used namespaced API controllers
- Implemented validation at the model level
- Designed for future extensibility


## How to import data Level 03
[Manual](import.md)