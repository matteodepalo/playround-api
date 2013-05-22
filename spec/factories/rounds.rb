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
#  index_rounds_on_game_id  (game_id)
#

FactoryGirl.define do
  factory :round do
    user
    after(:build) { |r| r.game = Game.where(name: :dota2).first || Game.build_and_create(name: :dota2) }
  end
end
