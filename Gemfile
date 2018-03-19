# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Specifying an exact Ruby version
ruby '2.4.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use Puma as the app server
gem 'puma', '~> 3.8'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Twitter Bootstrap SCSS for stylesheets
gem 'bootstrap-sass', '~> 3.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 3.2.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.6'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Authlogic is a clean, simple, and unobtrusive ruby authentication solution
gem 'authlogic'
# SCrypt is the default provider for Authlogic
gem 'scrypt'
# CanCanCan is an authorization library which restricts what resources a given user is allowed to access
gem 'cancancan', '~> 2.0'
# Use Faker to easily generate fake data: names, addresses, phone numbers, etc.
gem 'faker', '~> 1.7'
# Use Will Paginate for performing paginated queries with Active Record
gem 'will_paginate', '~> 3.1'
# Use Bootstrap Will Paginate to format the html to match Twitter Bootstrap styling
gem 'bootstrap-will_paginate', '~> 1.0'
# Easily add Growl-like notifications
gem 'gritter', '~> 1.2'
# Use CarrierWave to upload files
gem 'carrierwave', '~> 1.1'
# Use Mini Magick to manipulate images with minimal use of memory
gem 'mini_magick', '~> 4.7'
# Use google drive to upload and download files through cloud services library fog
gem 'fog-google'
gem 'google-api-client', '> 0.8.5', '< 0.9'
gem 'mime-types'
# Find out which locale the user preferes by reading the languages they specified in their browser
gem 'http_accept_language', '~> 2.1'
# Use rails-i18n to get default pluralization and transliteration rules
gem 'rails-i18n', '~> 5.0' # For 5.0.x and 5.1.x
# I18n ActiveRecord backend and support code
gem 'i18n-active_record', require: 'i18n/active_record'
# I18n library for ActiveRecord model/data translation
# gem 'globalize', git: 'https://github.com/globalize/globalize'
# gem 'activemodel-serializers-xml'
# Translations for the will_paginate gem
gem 'will-paginate-i18n', '~> 0.1'
# SDK for Facebook. It allows read/write access to the social graph
gem 'koala', '~> 3.0'
# Collection of filters for transforming text into HTML code
gem 'auto_html', '~> 2.0'
# simplest and a robust captcha plugin for Google reCAPTCHA API
gem 'recaptcha', require: 'recaptcha/rails'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Step-by-step debugging and stack navigation in Pry
  gem 'pry-byebug', platform: :ruby
  # Pry is a powerful alternative to the standard IRB shell for Ruby
  gem 'pry-rails'
  # Pretty print your Ruby objects with style -- in full color and with proper indentation. Use with 'ap object'
  gem 'awesome_print'
  # Shim to load environment variables from .env into ENV
  gem 'dotenv-rails'
  # Preview email in the default browser instead of sending it.
  gem 'letter_opener'
  # Behaviour Driven Development for Ruby
  gem 'rspec-rails'
  # RSpec::CollectionMatchers lets you express expected outcomes on collections of an object in an example
  gem 'rspec-collection_matchers'
  # Speedup RSpec + Cucumber by running parallel on multiple CPU cores
  gem 'parallel_tests'
  # Pretty print your Ruby objects with style -- in full color and with proper indentation. Use with 'ap object'
  gem 'awesome_print'
  # Add a comment summarizing the current schema to the top or bottom of each of your ActiveRecord models, Specs, factory_girl factories...
  gem 'annotate'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.1'
  # Better Errors replaces the standard Rails error page with a much better and more useful error page.
  gem 'better_errors'
  # necessary to use Better Errors' advanced features
  gem 'binding_of_caller', platforms: :ruby
  # bundler-audit provides patch-level verification for Bundled apps
  gem 'bundler-audit', '~> 0.6.0', require: false
  # compare licenses against a user-defined whitelist, and give you an actionable exception report
  gem 'license_finder', '~> 3.0', '>= 3.0.1', require: false
  # Use for fighting the N+1 problem in Ruby
  gem 'bullet'
  # Brakeman is an open source static analysis tool which checks Rails applications for security vulnerabilities.
  gem 'brakeman', require: false
  # Use i18n-tasks to find and manage missing and unused translations
  gem 'i18n-tasks', '~> 0.9.15', require: false
  # IYE makes it easy to translate your Rails I18N files and keeps them up to date
  gem 'iye', require: false
  # setup your favicon
  gem 'rails_real_favicon', require: false
  # RuboCop configuration which has the same code style checking as official Ruby on Rails
  gem 'rubocop', '~> 0.51.0', require: false
  gem 'guard-rubocop', require: false
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0'
end

group :test do
  gem 'guard', '~> 2.14'
  gem 'guard-minitest', '~> 2.4'
  gem 'minitest-reporters', '~> 1.1'
  # bring back the original controller testing for Authlogic
  gem 'rails-controller-testing', '~> 1.0'
  # Strategies for cleaning databases in Ruby. Can be used to ensure a clean state for testing.
  gem 'database_cleaner'
  # Code coverage for Ruby
  gem 'simplecov', require: false
  # Collection of testing matchers extracted from Shoulda
  gem 'shoulda-matchers'
end

group :production do
  # Use postgreSQL for heroku
  gem 'pg', '>= 0.20.0'
end

if Gem.win_platform?
  # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
  gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
  # to avoid polling for changes
  gem 'wdm', '>= 0.1.0'
end
