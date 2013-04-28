# == Schema Information
#
# Table name: api_keys
#
#  id           :uuid             not null, primary key
#  access_token :string(255)
#  user_id      :uuid
#  created_at   :datetime
#  updated_at   :datetime
#
# Indexes
#
#  index_api_keys_on_access_token  (access_token) UNIQUE
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :api_key do
  end
end
