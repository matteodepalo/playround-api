require 'spec_helper'

describe Team do
  let(:round) { create :round }

  it 'is invalid if the name is not among the round game team names' do
    Team.new(round: round, name: 'test').should be_invalid
    Team.new(round: round, name: round.game.team_names.first).should be_valid
  end

  it 'is full when the number of participations matches the number of players' do
    team = create :team, round: round, name: 'radiant'
    team.full?.should be_false
    team.round.game.number_of_players.times { Participation.create(team: team, user: create(:user)) }
    team.full?.should be_true
  end
end
