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
bin/rspec
```

## Design Considerations
- Used namespaced API controllers
- Implemented validation at the model level
- Designed for future extensibility

## API Collection for Postman
[Postman Collection](https://.postman.co/workspace/My-Workspace~bbc4ebbc-afd9-4da4-814c-f9c41ce71eb8/collection/43546751-d6a274bb-1a3c-4557-adf2-b7306cdfe525?action=share&creator=43546751)


## How to import data Level 03
[Manual](import.md)