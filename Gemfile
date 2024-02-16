source "https://rubygems.org"

ruby "3.3.0"

# CORE
gem "rails", "~> 7.1.1"
gem "sqlite3", "~> 1.4"
gem "puma", ">= 5.0"

# FRONTEND
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails", "~> 2.0"

# OTHER
gem "bootsnap", require: false

group :development, :test do
  gem "debug"
  gem "faker"
  gem "factory_bot_rails"
end

group :development do
  gem "hotwire-livereload", "~> 1.3"
  gem "web-console"
  gem "rubocop-rails-omakase", require: false
  gem "brakeman", require: false
  gem "redis"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov", require: false
end
