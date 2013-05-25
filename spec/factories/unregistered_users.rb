# == Schema Information
#
# Table name: unregistered_users
#
#  id            :uuid             not null, primary key
#  facebook_id   :string(255)
#  foursquare_id :string(255)
#  name          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_unregistered_users_on_facebook_id    (facebook_id)
#  index_unregistered_users_on_foursquare_id  (foursquare_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :unregistered_user do
    facebook_id '123'
    foursquare_id nil
    name 'Test User'
  end
end
