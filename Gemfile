source "https://rubygems.org"

ruby '1.9.3'
gem "rails", "3.2.8"

# Bundle edge Rails instead:
# gem "rails", :git => "git://github.com/rails/rails.git"
group :development, :test do
  gem "sqlite3"
end

group :production do
  gem "pg"
end

gem "haml", "~> 3.1.7"
gem "haml-rails", "~> 0.3.5"

# Authorization (probably overkill, but it's a proto so no big deal)
gem "devise", "~> 2.1.2"
gem "cancan", "~> 1.6.8"

# Using rails admin for site maintenance
gem "rails_admin", "~> 0.2.0"

# Gems only used in development
group :development do
  gem "syntax", "~> 1.0.0"
  gem 'quiet_assets', "~> 1.0.1"
  gem "rspec-rails", "~> 2.11.0"  # used for generators
  gem "miniskirt", "~> 1.2.1"
end

# Gems only used for tests
group :test do
  gem "syntax", "~> 1.0.0"
  gem "database_cleaner", "~> 0.8.0"
  gem "rspec-rails", "~> 2.11.0"
  gem "shoulda-matchers", "~> 1.4.0"
  gem "miniskirt", "~> 1.2.1"
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails",   "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
  gem "compass-rails", "~> 1.0.3"
  gem "zurb-foundation", "~> 3.2.0"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  #gem "therubyracer", :platforms => :ruby
  
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
