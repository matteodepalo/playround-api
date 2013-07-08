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

require 'spec_helper'

describe Round do
  it 'has `waiting_for_players` as initial state' do
    round = build :round
    round.should be_waiting_for_players
  end

  it 'transitions to `ongoing` from `waiting_for_players`' do
    round = build :round
    round.start
    round.should be_ongoing
  end

  it 'transitions to `over` from `ongoing`' do
    round = build :round
    round.start
    round.finish
    round.should be_over
  end

  it 'can\'t transtion from `waiting_for_players` to `over`' do
    round = build :round
    round.finish
    round.should_not be_over
  end

  it 'is not valid without a game' do
    round = build :round
    round.game = nil
    round.should_not be_valid
  end

  it 'raises error when assigning a wrong game_name' do
    round = build :round
    round.game_name = :invalid_game
    round.should be_invalid
    round.game_name = :dota2
    round.should be_valid
  end

  it 'assigns the correct game with game_name' do
    round = build :round, game_name: :table_football
    round.game_name = :table_football
    round.game_name.should eq('Table Football')
  end

  it 'cannot have its game changed after it is created' do
    round = create :round, game_name: :table_football
    round.game_name = :go
    round.should be_invalid
    round.errors.full_messages.should include('Game cannot be changed after creation')
  end

  it 'can assign participants' do
    user = create :user
    round = build :round
    facebook_users = [MATTEO_DEPALO, EUGENIO_DEPALO]

    round.participations = [
      { user: { id: user.id } },
      { user: { facebook_id: MATTEO_DEPALO['id'] } },
      { team: 'dire', user: { facebook_id: EUGENIO_DEPALO['id'] } }
    ]

    round.save

    users = round.participations.map(&:user)
    users.count.should eq(3)
    users.first.name.should eq(user.name)
    users[1..2].map(&:facebook_id).should eq(facebook_users.map { |u| u['id'] })
    users[1..2].map(&:name).should eq(['Matteo Depalo', 'Eugenio Depalo'])
    round.participations.map(&:team).should eq(['radiant', 'radiant', 'dire'])
  end

  it 'creates a new arena with the arena setter' do
    foursquare_id = attributes_for(:arena)[:foursquare_id]
    round = build :round
    round.arena = { foursquare_id: foursquare_id }
    round.save

    round.arena.foursquare_id.should eq(foursquare_id)
  end

  it 'has a list of available teams' do
    round = create :round, game_name: :go
    round.available_teams.should eq(['black', 'white'])
    create :participation, round: round, team: 'black'

    round.available_teams.should eq(['white'])

    round = create :round, game_name: :dota2
    round.available_teams.should eq(['radiant', 'dire'])
    create :participation, round: round, team: 'radiant'

    round.available_teams.should eq(['radiant', 'dire'])
  end

  it 'transitions to ongoing when the it is full of participants' do
    round = create :round, game_name: :dota2
    round.game.number_of_players.times { round.users << create(:user) }

    round.reload
    round.state.should eq('ongoing')
  end
end
