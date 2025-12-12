source "https://rubygems.org"

ruby "3.4.1"

# CORE
gem "rails", "~> 8.1"
gem "puma", ">= 5.0"
gem "sqlite3", ">= 2.1"
gem "bcrypt", "~> 3.1.7"
gem "solid_cache"
gem "solid_cable"
gem "groupdate"
gem "csv"

# FRONTEND
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails", "~> 4.0"
gem "view_component"

# OTHER
gem "bootsnap", require: false
gem "kamal", "~> 2.5", require: false
gem "thruster", "~> 0.1", require: false
gem "honeybadger", "~> 6.2"

group :development, :test do
  gem "debug"
  gem "faker"
  gem "factory_bot_rails"
  gem "standard"
  gem "standard-rails"
end

group :development do
  gem "web-console"
  gem "brakeman", require: false
  gem "hotwire-spark"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov", require: false
end
