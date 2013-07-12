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
    round.should be_invalid
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
    round.errors[:game].first.should eq('cannot be changed after creation')
  end

  it 'find or initializes a team with find_or_initialize_team' do
    round = create :round

    team = round.find_or_initialize_team(round.game.team_names.first)
    team.name.should eq(round.game.team_names.first)
    team.save
    round.find_or_initialize_team(round.game.team_names.first).should eq(team)
  end

  it 'can assign participants' do
    user = create :user
    round = build :round
    facebook_users = [MATTEO_DEPALO, EUGENIO_DEPALO]

    round.teams = [
      {
        name: 'radiant',
        participations: [
          { user: { id: user.id } }
        ]
      },
      {
        name: 'dire',
        participations: [
          { user: { facebook_id: EUGENIO_DEPALO['id'] } },
          { user: { facebook_id: MATTEO_DEPALO['id'] } }
        ]
      }
    ]

    round.save

    users = round.participations.map(&:user)
    users.count.should eq(3)
    round.teams.where(name: 'radiant').first.users.should eq([user])
    round.teams.where(name: 'dire').first.users.map(&:facebook_id).should eq(facebook_users.map { |u| u['id'] })
  end

  it 'creates a new arena with the arena setter' do
    foursquare_id = attributes_for(:arena)[:foursquare_id]
    round = build :round
    round.arena = { foursquare_id: foursquare_id }
    round.save

    round.arena.foursquare_id.should eq(foursquare_id)
  end

  it 'transitions to ongoing when the it is full of participants' do
    round = create :round

    round.game.number_of_players.times do
      Participation.create(team: round.teams.create(name: round.game.team_names.first), user: create(:user))
    end

    round.reload
    round.state.should eq('ongoing')
  end

  it 'can decare a winner via the declare_winner method' do
    round = create :full_round
    round.reload
    round.declare_winner('radiant')
    round.teams.where(name: 'radiant').first.winner.should eq(true)
    round.should be_over
  end
end
