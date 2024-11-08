source "https://rubygems.org"

ruby "3.3.0"

# CORE
gem "rails", "~> 8.0"
gem "puma", ">= 5.0"
gem "sqlite3", ">= 2.1"
gem "bcrypt", "~> 3.1.7"
gem "solid_cache"
gem "solid_cable"

# FRONTEND
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails", "~> 2.6"
gem "view_component"

# OTHER
gem "bootsnap", require: false
gem "kamal", "~> 1.9"

group :development, :test do
  gem "debug"
  gem "faker"
  gem "factory_bot_rails"
end

group :development do
  gem "hotwire-livereload", "~> 1.4"
  gem "web-console"
  gem "rubocop-rails-omakase", require: false
  gem "brakeman", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov", require: false
end
