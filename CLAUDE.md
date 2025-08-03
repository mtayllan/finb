# FinB - Financial Budget Management Application

## Overview

FinB is a personal finance management application built with Ruby on Rails 8.0. It's designed to help users track expenses, manage accounts, categorize transactions, and generate financial reports. The application uses SQLite for data storage and features a modern UI built with Tailwind CSS and Hotwire (Turbo + Stimulus).

## Architecture

### Technology Stack

- **Backend**: Ruby on Rails 8.0
- **Database**: SQLite3 with Solid Cache and Solid Cable
- **Frontend**: 
  - Tailwind CSS 4.0 for styling
  - Hotwire (Turbo Rails + Stimulus) for interactivity
  - ViewComponent for UI components
  - Importmap for JavaScript management
- **Authentication**: Custom implementation using bcrypt
- **Deployment**: Docker-ready with Kamal support

### Key Features

1. **Multi-Account Management**
   - Support for different account types: checking, savings, credit card, investment
   - Automatic balance calculation and tracking
   - Initial balance setup with custom dates
   - Color-coded accounts for visual organization

2. **Transaction Management**
   - Income and expense tracking
   - Category-based organization
   - Transaction descriptions
   - Support for installment transactions
   - Date validation to ensure data integrity

3. **Credit Card Features**
   - Credit card statement tracking
   - Monthly statement generation
   - Statement payment functionality
   - Automatic transaction-statement association

4. **Transfer Management**
   - Money transfers between accounts
   - Automatic balance updates for both origin and target accounts

5. **Reporting System**
   - Daily balance reports with charts
   - Income by category analysis
   - Expenses by category analysis
   - Visual charts using JavaScript controllers

6. **Data Management**
   - Import/Export functionality for data backup
   - User data isolation (multi-user support)

## Database Schema

### Core Models

1. **User** - System users with authentication
   - username (unique)
   - password_digest (bcrypt)

2. **Account** - Financial accounts
   - name, color, kind (enum)
   - initial_balance, balance
   - initial_balance_date
   - credit_card_expiration_day (for credit cards)
   - Belongs to User

3. **Transaction** - Financial transactions
   - description, value, date
   - Belongs to Account, Category
   - Optional: credit_card_statement

4. **Category** - Transaction categories
   - name, color, icon
   - Belongs to User

5. **Transfer** - Money transfers between accounts
   - description, value, date
   - origin_account_id, target_account_id

6. **CreditCard::Statement** - Credit card statements
   - month, value, paid_at
   - Belongs to Account

7. **Account::Balance** - Daily balance snapshots
   - date, balance
   - Belongs to Account

## Project Structure

```
/app
├── controllers/         # MVC Controllers
│   ├── accounts/       # Account-related controllers
│   ├── credit_cards/   # Credit card controllers
│   ├── reports/        # Reporting controllers
│   └── settings/       # Settings controllers
├── models/             # ActiveRecord models
│   ├── account/        # Account-related models
│   ├── credit_card/    # Credit card models
│   └── data_management/ # Import/Export logic
├── views/              # ERB templates
│   └── components/     # ViewComponent UI components
└── javascript/         # Stimulus controllers
    └── controllers/    # Frontend interactivity
```

## Key Workflows

### Authentication Flow
- Session-based authentication using signed cookies
- Custom Session model for token management
- Before-action authentication in ApplicationController

### Balance Calculation
- Automatic balance updates on transaction/transfer changes
- Daily balance calculation with caching
- Account::UpdateBalances service for historical balance tracking

### Credit Card Management
- Transactions can be associated with credit card statements
- Statements are automatically created based on transaction dates
- Statement values are calculated from associated transactions

## Development Guidelines

### Running the Application

```bash
# Using Docker (recommended)
docker build -t finb .
docker run -d -p 9090:3000 --name finb -v finb-storage:/rails/storage --env SECRET_KEY_BASE=1 finb

# Local development
bundle install
rails db:create db:migrate
./bin/dev  # Runs Rails server with Tailwind CSS watch
```

### Testing
- Uses Minitest with FactoryBot for test data
- SimpleCov for code coverage
- Capybara for system tests

### Code Quality
- Standard Ruby linter
- Brakeman for security analysis
- Hotwire Spark for development

### Important Commands

```bash
# Run tests
rails test

# Run linter
bundle exec standardrb

# Security check
bundle exec brakeman

# Database operations
rails db:migrate
rails db:seed
```

## Security Considerations

- CSRF protection enabled
- Authentication required for all actions (except login)
- User data isolation through associations
- Parameterized queries to prevent SQL injection
- Secure password storage with bcrypt

## Performance Optimizations

- Solid Cache for caching
- Solid Cable for WebSocket connections
- Daily balance caching to reduce recalculation
- Efficient queries with proper indexes
- Hotwire for reduced page reloads

## Future Enhancements

Based on the current codebase structure, potential areas for enhancement:

1. API endpoints for mobile app integration
2. Budget planning and goals
3. Recurring transaction support
4. Multi-currency support
5. Advanced reporting with PDF export
6. Notification system for bill reminders