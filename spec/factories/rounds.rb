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
      r.arena = { foursquare_id: attributes_for(:arena)[:foursquare_id] }
    end

    factory :full_round do
      after(:create) do |r|
        r.game.team_names.each { |name| create :team, round: r, name: name }
        r.game.teams.each do |team|
          team[:number_of_players].times do
            r.teams.where(name: team[:name]).first.participations.create(user: create(:user))
          end
        end
      end
    end
  end
end
