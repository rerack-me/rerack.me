source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

# manage authentication and authorization
gem 'devise'

# for testing
gem 'factory_girl_rails'

# pagination
gem 'will_paginate'
gem 'will_paginate-bootstrap'

# haml for layout
gem 'haml'

# for twitter typeahead
gem 'twitter-typeahead-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

group :development do
  # fake name generator
  # does not play nice with Heroku
  gem 'faker'
end

# Experimental Bootstrap 3.0 beta -- use at your own risk.
gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# use a better server
gem 'thin'

# cancan for permissions management
gem 'cancan'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
