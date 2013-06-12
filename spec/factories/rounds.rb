# == Schema Information
#
# Table name: rounds
#
#  id         :uuid             not null, primary key
#  state      :string(255)
#  game_id    :uuid
#  arena_id   :uuid
#  user_id    :uuid
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_rounds_on_arena_id  (arena_id)
#  index_rounds_on_game_id   (game_id)
#  index_rounds_on_user_id   (user_id)
#

FactoryGirl.define do
  factory :round do
    user
    game_name 'dota2'
    after(:build) do |r|
      r.arena_properties = { foursquare_id: attributes_for(:arena)[:foursquare_id] }
    end
  end
end
