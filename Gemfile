source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Specifying an exact Ruby version
ruby '2.4.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
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
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1'
# Use Faker to easily generate fake data: names, addresses, phone numbers, etc.
gem 'faker', '~> 1.7'
# Use Will Paginate for performing paginated queries with Active Record
gem 'will_paginate', '~> 3.1'
# Use Bootstrap Will Paginate to format the html to match Twitter Bootstrap styling
gem 'bootstrap-will_paginate', '~> 1.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # Use IRB alternative for better code completion in console
  gem 'pry'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :development do
  # Use with 'ap object' for nice print Ruby objects in console
  gem 'awesome_print'
  # Use for fighting the N+1 problem in Ruby
  gem 'bullet'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'rails-controller-testing', '~> 1.0'
  gem 'minitest-reporters',       '~> 1.1'
  gem 'guard',                    '~> 2.14'
  gem 'guard-minitest',           '~> 2.4'

end

group :production do
  # Use postgreSQL for heroku
  gem 'pg', '>= 0.20.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
