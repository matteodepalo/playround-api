# == Schema Information
#
# Table name: teams
#
#  id         :uuid             not null, primary key
#  name       :string(255)
#  round_id   :uuid
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_teams_on_round_id  (round_id)
#

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

  it 'has a winner field that can be true only once per round' do
    team = create :team, round: round, name: 'radiant'
    team.winner.should eq(false)
    team.win
    team2 = create :team, round: round, name: 'dire'
    team2.winner = true
    team2.should be_invalid
    team2.errors.full_messages.should include('Winner can be true for one team per round')
  end
end
