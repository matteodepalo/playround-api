require 'spec_helper'

describe Winning do
  before(:each) do
    @round = create :full_round
    @round.reload
  end

  it 'declares the winner of the round via the save method' do
    winning = Winning.new(round: @round, team_name: 'radiant')
    winning.save

    @round.reload
    @round.should be_over
    @round.teams.where(winner: true).first.name.should eq('radiant')
  end

  it 'is not valid if the team name is not among the valid ones' do
    winning = Winning.new(round: @round, team_name: 'lol')
    winning.should be_invalid
    winning.errors[:team_name].first.should eq("must be among: #{@round.game.team_names.join(', ')}")
  end

  it 'is not valid if the round is not ongoing' do
    winning = Winning.new(round: create(:round), team_name: 'radiant')
    winning.should be_invalid
    winning.errors[:round].first.should eq("must be ongoing")
  end
end