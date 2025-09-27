# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About the project

FinB is a Personal Finances Manager

## Common Development Commands

### Development Server
- `bin/dev` - Start development server (Rails, Vite)
- `bin/rails server` - Start Rails server only
- `bin/rails console` - Open Rails console

### Testing
- `bin/rails test` - Run all tests
- `bin/rails test:db` - Run tests with database reset
- `bin/rails test:system` - Run system tests only (use sparingly - they take longer)
- `bin/rails test test/models/article_test.rb` - Run specific test file
- `bin/rails test test/models/article_test.rb:42` - Run specific test at line

### Linting & Formatting
- `bundle exec standardrb` - Run Standard.rb linter
- `bin/brakeman` - Run security analysis

## General Development Rules

### Authentication Context
- Use `Current.user` for the current user. Do NOT use `current_user`.

### Development Guidelines
- Prior to generating any code, carefully read the project conventions and guidelines
- Ignore i18n methods and files. Hardcode strings in english to optimize speed of development
- Do not run `rails server` in your responses
- Do not run `touch tmp/restart.txt`
- Do not run `rails credentials`

## High-Level Architecture

### Core Domain Model
- `User` - Represents a user of the system
- `Account` - Represents a financial account, belongs only to a User
  - `Balance` - Represents the current balance of an Account at a specific date
- `Transaction` - Represents a financial transaction, belongs to an Account
- `Category` - Represents a category for transactions, belongs to a User
- `Transfer` - Represents a transfer between accounts, belongs to two Accounts
- `Session` - Represents a user session, used for authentication

### Project Conventions

- Prioritize good OOP code, do not create `app/services` module.
- All business logic goes on app/models. Create a new object scoped to the principal model when developing a complex business logic scenario. Example: `app/models/account/update_balances.rb`
- If a model belongs mainly to another one, create it scoped to the other. Example: `app/models/account/balance.rb`


### Frontend Architecture
- **Hotwire Stack**: Turbo + Stimulus for reactive UI without heavy JavaScript
- **ViewComponents**: Reusable UI components in `app/views/components/`
  - `ui` for pure components
  - `app_ui` for app related components
- **Stimulus Controllers**: Handle interactivity, organized alongside components
- **Styling**: Tailwind CSS v4 with Daisy UI https://daisyui.com/
- Icons with **Phosphor Icons** lib
- User rails importmaps to install JS packages


### Testing Philosophy
- Comprehensive test coverage using Rails' built-in Minitest
- Use fixtures for default test data, like a default User, Account, or Category
- Use FactoryBot for complex scenarios, like filters
- Keep fixtures minimal (2-3 per model for base cases)
- Only test critical code paths that significantly increase confidence
- Write tests as you go, when required
- Only mock what's necessary

### Performance Considerations
- Database queries optimized with proper indexes
- N+1 queries prevented via includes/joins
- Background jobs for heavy operations
- Caching strategies for expensive calculations
- Turbo Frames for partial page updates

### ViewComponent vs Partials Decision Making

**Use ViewComponents when:**
- Element has complex logic or styling patterns
- Element will be reused across multiple views/contexts
- Element needs structured styling with variants/sizes
- Element requires interactive behavior or Stimulus controllers
- Element has configurable slots or complex APIs
- Element needs accessibility features or ARIA support

**Use Partials when:**
- Element is primarily static HTML with minimal logic
- Element is used in only one or few specific contexts
- Element is simple template content
- Element doesn't need variants, sizes, or complex configuration
- Element is more about content organization than reusable functionality

**Component Guidelines:**
- Prefer components over partials when available
- Keep domain logic OUT of view templates
- Logic belongs in component files, not template files

## Git Commit Instructions
The commit message should follow this format:
```
<header>
<BLANK LINE>
<body>
```

Among them, <header> is mandatory.

The header format is:

```
<type>: <short summary>
```

```
Type: build|ci|docs|feat|fix|perf|refactor|test
Summary: in present tense. Not capitalized. No period at the end.
```

<scope> indicates the scope of the change

<summary> is a brief description of the commit, using imperative mood and present tense. For example, use change instead of changed or changes.

<body> is a more detailed description of the commit message, also using imperative mood and present tense like <header>. <body> describes the motivation for the change, such as why the change was introduced, what the previous logic was, what the current logic is, and what impact the change has.

**IMPORTANT**: Do NOT add co-authoring information (Co-Authored-By) to commit messages

