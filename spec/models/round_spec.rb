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

  it 'assigns the correct game with game_name' do
    game = Game.build_and_create(name: :table_football)
    round = build :round
    round.game_name = :table_football
    round.game_name.should eq('Table Football')
  end

  it 'is not possible to change game to a round after it is created' do
    game = Game.build_and_create(name: :table_football)
    round = create :round
    round.game_name = :table_football
    round.should be_invalid
    round.errors.full_messages.should include('Game cannot be changed after creation')
  end
end
