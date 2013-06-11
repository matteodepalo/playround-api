ruby '2.0.0'
source 'http://rubygems.org'

gem 'rails', '4.0.0rc2'
gem 'rails-api'
gem 'pg'
gem 'state_machine'
gem 'oj'
gem 'active_model_serializers'
gem 'annotate', git: 'git://github.com/ctran/annotate_models.git'
gem 'koala'
gem 'cancan'
gem 'unicorn'
gem 'foursquare2'
gem 'dotenv'

group :development do
  gem 'capistrano'
  gem 'knife-solo'
  gem 'debugger', git: 'git://github.com/cldwalker/debugger.git', require: false
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