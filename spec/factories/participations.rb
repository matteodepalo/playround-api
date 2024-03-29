# == Schema Information
#
# Table name: participations
#
#  id         :uuid             not null, primary key
#  team_id    :uuid
#  user_id    :uuid
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_participations_on_team_id  (team_id)
#  index_participations_on_user_id  (user_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :participation do
    team
    user
  end
end
