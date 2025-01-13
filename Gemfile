source "https://rubygems.org"

ruby "3.3.5"

# CORE
gem "rails", "~> 8.0"
gem "puma", ">= 5.0"
gem "sqlite3", ">= 2.1"
gem "bcrypt", "~> 3.1.7"
gem "solid_cache"
gem "solid_cable"
gem "groupdate"

# FRONTEND
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails", "~> 3.2"
gem "view_component"

# OTHER
gem "bootsnap", require: false
gem "kamal", "~> 2.3", require: false
gem "thruster", "~> 0.1", require: false

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
