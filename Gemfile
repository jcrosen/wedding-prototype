source "https://rubygems.org"

ruby '1.9.3'
gem "rails", "3.2.12"

# Bundle edge Rails instead:
# gem "rails", :git => "git://github.com/rails/rails.git"
group :development, :test do
  gem "sqlite3"
end

group :production do
  gem "pg"
  gem 'newrelic_rpm'
end

gem "haml", "~> 4.0.0"
gem "haml-rails", "~> 0.4"

# Authorization (probably overkill, but it's a proto so no big deal)
gem "devise", "~> 2.1.2"
gem "cancan", "~> 1.6.8"

# Using rails admin for site maintenance
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

# Using factories to create data
gem "miniskirt", "~> 1.2.1", require: false

gem "redcarpet", "~> 2.2.2"
gem "rails-backbone", "~> 0.9.0"
gem "rest-client", "~> 1.6.7"

# Gems only used in development
group :development do
  gem "syntax", "~> 1.0.0"
  gem 'quiet_assets', "~> 1.0.1"
  gem "rspec-rails", "~> 2.11.0"  # used for generators
  gem 'hpricot'
  gem 'ruby_parser'
end

# Gems only used for tests
group :test do
  gem "syntax", "~> 1.0.0"
  gem "database_cleaner", "~> 0.8.0"
  gem "rspec-rails", "~> 2.11.0"
  gem "shoulda-matchers", "~> 1.4.0"
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails",   "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
  gem "compass-rails", "~> 1.0.3"
  gem "less-rails", "~> 2.2.6"
  gem "twitter-bootstrap-rails", "~> 2.2.4"
  gem "haml_coffee_assets", "~> 1.11.1"
  gem "execjs", "~> 1.4.0"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem "therubyracer", :platforms => :ruby
  
  gem "uglifier", ">= 1.0.3"
end

gem "jquery-rails"

# To use ActiveModel has_secure_password
# gem "bcrypt-ruby", "~> 3.0.0"

# To use Jbuilder templates for JSON
# gem "jbuilder"

# Use unicorn as the app server
gem "unicorn"

# Deploy with Capistrano
# gem "capistrano"

# To use debugger
# gem "debugger"
