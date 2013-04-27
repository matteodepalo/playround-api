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
end
