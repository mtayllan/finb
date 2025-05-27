# GitHub Copilot Instructions for Finb

## Project Overview

FinB is Personal Finances Manager

## Technology Stack

- **Backend**: Ruby on Rails 8.0, PostgreSQL
- **Frontend**: Rails Importmaps, Hotwire (Turbo, Stimulus), TailwindCSS 4, ViewComponent, DaisyUI

## Code Organization

### Models Structure

- `User` - Represents a user of the system
- `Account` - Represents a financial account, belongs only to a User
  - `Balance` - Represents the current balance of an Account at a specific date
- `Transaction` - Represents a financial transaction, belongs to an Account
- `Category` - Represents a category for transactions, belongs to a User
- `Transfer` - Represents a transfer between accounts, belongs to two Accounts
- `Session` - Represents a user session, used for authentication

## Coding Conventions

- Push Rails to its limits before adding new dependencies
- When a new dependency is added, there must be a strong technical or business reason to add it
- When adding dependencies, you should favor old and reliable over new and flashy
- Prioritize good OOP domain design over performance
- Organize large pieces of business logic into Rails concerns and POROs
- While a Rails concern _may_ offer shared functionality (i.e. "duck types"), it can also be a "one-off" concern that is only included in one place for better organization and readability.
- When concerns are used for code organization, they should be organized around the "traits" of a model; not for simply moving code to another spot in the codebase.
- When possible, models should answer questions about themselves—for example, we might have a method, `account.calculate_balances` that calculate account's balances. We prefer this over something more service-like such as `Account::Balance::Calculate.new(account).call`.

### Ruby/Rails Conventions

- Follow standard Rails naming conventions
- Use namespaces for separation of concerns
- Models use proper ActiveRecord associations and validations
- Controllers follow RESTful patterns

### JavaScript Conventions

- Use Stimulus controllers for JavaScript functionality
- Follow Hotwire patterns for enhanced interactivity

### Component Structure

- UI components built using ViewComponent gem
- Component files stored in app/views/components

## Testing

- Do not write system tests
- Only write tests for critical and important code paths
- Use Minitest + Fixtures for testing, minimize fixtures
- Keep fixtures to a minimum.  Most models should have 2-3 fixtures maximum that represent the "base cases" for that model. "Edge cases" should be created on the fly, within the context of the test which it is needed
- Take a minimal approach to testing—only test the absolutely critical code paths that will significantly increase developer confidence
