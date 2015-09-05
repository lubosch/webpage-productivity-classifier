source 'https://rubygems.org'

gem 'dotenv-rails'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use postgres as the database for Active Record
gem 'pg'
# PgSearch builds named scopes that take advantage of PostgreSQL's full text search.
gem 'pg_search'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

gem 'devise'
gem 'devise-i18n'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-linkedin'
gem 'cancan'

gem 'doorkeeper'

gem 'rename'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 5'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Use haml for views
gem 'haml-rails'
# jquery loading bar
gem 'nprogress-rails'
# puma web server
gem 'puma'
# bootstrap-sass
gem 'bootstrap-sass'
gem 'bootstrap-modal-rails'

gem 'annotate'

# gem 'angular_rails_csrf'

# gem 'neo4j', branch: :master
gem 'neo4j', github: 'andreasronge/neo4j'
# gem 'neo4j-core', branch: :master
gem 'mechanize'
gem 'faraday'

gem 'unobtrusive_flash', '>=3'
# Remotipart is a Ruby on Rails gem enabling AJAX file uploads
gem 'remotipart', '~> 1.2'

# gem for language recognition based on browser header Accept-Language property
gem 'http_accept_language'

gem 'fast-stemmer'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'rails_12factor', group: :production

group :development do
  gem 'rails_layout'
  gem 'capistrano-rails'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'

  gem 'rspec-rails', '~> 3'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end


group :test do
  gem 'capybara', '~> 2.4.4'
  gem 'capybara-webkit'
  gem 'capybara-screenshot'
  gem 'debase'
  gem 'fakeweb', '~> 1.3'
  gem 'selenium-webdriver', '~> 2.45'
  gem 'chromedriver-helper'
  gem 'database_cleaner', '~> 1.0.1'
  gem 'launchy', '~> 2.3.0'
  gem 'cucumber-rails', :require => false
  gem 'simplecov', :require => false
  gem 'vcr', '~> 2.9.2'
  gem 'webmock', '~> 1.18.0', :require => false
end


group :development, :production, :test do
  gem 'faker', '~> 1.2'
  gem 'factory_girl', '~> 4.5.0'
end

ruby "2.2.2"