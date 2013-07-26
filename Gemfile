ruby '2.0.0'
source 'https://rubygems.org'

gem 'rails'
gem 'rails-api'
gem 'pg'
gem 'state_machine'
gem 'oj'
gem 'active_model_serializers'
gem 'annotate', github: 'ctran/annotate_models'
gem 'koala'
gem 'cancan'
gem 'unicorn'
gem 'foursquare2'
gem 'dotenv'
gem 'warden', github: 'hassox/warden'
gem 'activerecord-postgis-adapter'

group :development do
  gem 'capistrano'
  gem 'knife-solo'
  gem 'debugger'
  gem 'rgeo-shapefile'
  gem 'dbf'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'database_cleaner'
  gem 'vcr'
  gem 'webmock'
end