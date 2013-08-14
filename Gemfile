ruby '2.0.0'
source 'https://rubygems.org'

gem 'rails'
gem 'rails-api'
gem 'pg'
gem 'state_machine'
gem 'active_model_serializers'
gem 'koala'
gem 'cancan'
gem 'unicorn'
gem 'foursquare2'
gem 'dotenv'
gem 'warden', github: 'hassox/warden'
gem 'activerecord-postgis-adapter'
gem 'geocoder'

group :development do
  gem 'annotate', github: 'ctran/annotate_models'
  gem 'capistrano'
  gem 'knife-solo'
  gem 'debugger'
  gem 'rgeo-shapefile'
  gem 'rspec_api_blueprint', github: 'playround/rspec_api_blueprint'
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