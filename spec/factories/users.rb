# == Schema Information
#
# Table name: users
#
#  id          :uuid             not null, primary key
#  name        :string(255)
#  email       :string(255)
#  facebook_id :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_users_on_facebook_id  (facebook_id) UNIQUE
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'

    sequence :email do |n|
      "test#{n}@user.com"
    end

    sequence :facebook_id do |n|
      "12#{n}"
    end
  end
end
