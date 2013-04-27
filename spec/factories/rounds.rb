# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  state      :string(255)
#  game_id    :integer
#  arena_id   :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_rounds_on_game_id  (game_id)
#

FactoryGirl.define do
  factory :round do
  end
end
