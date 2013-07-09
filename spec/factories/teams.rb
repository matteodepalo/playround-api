# == Schema Information
#
# Table name: teams
#
#  id         :uuid             not null, primary key
#  name       :string(255)
#  round_id   :uuid
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_teams_on_round_id  (round_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team do
    name 'Example Team'
    round
  end
end
