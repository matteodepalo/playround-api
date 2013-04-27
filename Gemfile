ruby '2.0.0'
source 'http://rubygems.org'

gem 'rails', '4.0.0.beta1'
gem 'rails-api'
gem 'pg'
gem 'state_machine'
gem 'oj'
gem 'active_model_serializers'
gem 'annotate', git: 'git://github.com/ctran/annotate_models.git'

group :development do
  gem 'capistrano'
  gem 'knife-solo'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :deploy do
  gem 'unicorn'
end