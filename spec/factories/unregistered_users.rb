# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :unregistered_user do
    facebook_id '123'
    foursquare_id nil
    name 'Test User'
  end
end
