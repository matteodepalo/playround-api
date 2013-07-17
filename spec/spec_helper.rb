# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'
require 'webmock/rspec'
require 'data/arena_stubs'
require 'data/facebook_stubs'
require 'debugger'

Dotenv.load '.env'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join("spec", "vcr")
  config.hook_into :webmock
end

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join('/').underscore.gsub(/[^\w\/]+/, '_')
    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name, options) { example.call }
  end

  config.before(:each, type: :model) do
    Koala::Facebook::API.any_instance.stub(:get_object).with('me').and_return(MATTEO_DEPALO)
    Koala::Facebook::API.any_instance.stub(:get_object).with(MATTEO_DEPALO['id']).and_return(MATTEO_DEPALO)
    Koala::Facebook::API.any_instance.stub(:get_object).with(EUGENIO_DEPALO['id']).and_return(EUGENIO_DEPALO)
    Koala::Facebook::API.any_instance.stub(:batch).and_return(BATCH_MATTEO_EUGENIO)
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  # config.order = 'random'

  config.include FactoryGirl::Syntax::Methods
  config.include Test::Helpers

  config.before(:all) { DeferredGarbageCollection.start }
  config.after(:all) { DeferredGarbageCollection.reconsider }

  config.before(:suite) do
    Dir.glob(File.join(Rails.root, '/docs/', '*')).each do |f|
      File.delete(f)
    end

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    FOURSQUARE_CLIENT.stub(:venue).with('5104').and_return(EXAMPLE_ARENA)
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:each, type: :request) do
    example.metadata.to_s.match(/(\w+)\sRequests/)
    file_name = $1.underscore

    File.open(File.join(Rails.root, "/docs/#{file_name}.txt"), 'a') do |f|
      f.write "#{request.method} #{request.path} \n\n"

      request_body = request.body.read

      if request.headers['Authorization']
        f.write "Headers: \n\n"
        f.write "Authorization: #{request.headers['Authorization']} \n\n"
      end

      if request_body.present?
        f.write "Request: \n\n"
        f.write "#{JSON.pretty_generate(JSON.parse(request_body))} \n\n"
      end

      if response.body.present?
        f.write "Response body: \n\n"
        f.write "#{JSON.pretty_generate(JSON.parse(response.body))} \n\n"
      end
    end unless request.path == '/unauthenticated' || response.body.match('redirected')
  end
end