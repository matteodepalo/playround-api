# == Schema Information
#
# Table name: buddyships
#
#  id         :uuid             not null, primary key
#  user_id    :uuid
#  buddy_id   :uuid
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_buddyships_on_buddy_id  (buddy_id)
#  index_buddyships_on_user_id   (user_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :buddyship do
  end
end
