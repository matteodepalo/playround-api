# == Schema Information
#
# Table name: users
#
#  id          :uuid             not null, primary key
#  name        :string(255)
#  email       :string(255)
#  image       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  facebook_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Test User"
    email "test@user.com"
  end
end
