# == Schema Information
#
# Table name: participations
#
#  id         :uuid             not null, primary key
#  team_id    :uuid
#  user_id    :uuid
#  joined     :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_participations_on_team_id  (team_id)
#  index_participations_on_user_id  (user_id)
#

require 'spec_helper'

describe Participation do
  let(:user) { create :user }
  let(:round) { create :round, game_name: 'dota2' }

  it 'must have a non full team' do
    round = create :round, game_name: 'go'
    team = round.teams.create(name: round.game.team_names.first)
    participation = Participation.new(team: team, user: user)
    participation.should be_valid

    participation.save
    invalid_participation = Participation.new(team: team, user: create(:user))
    invalid_participation.should be_invalid
    invalid_participation.errors[:base].first.should eq('team is full')
  end

  it 'must have a unique combination of user and round' do
    team = round.teams.create(name: round.game.team_names.first)
    team2 = round.teams.create(name: round.game.team_names.last)
    create :participation, team: team, user: user
    participation = Participation.new(team: team2, user: user)

    participation.should be_invalid
    participation.errors[:base].first.should eq('user and round must be unique')
  end

  it 'must have a round waiting for players' do
    team = round.teams.create(name: round.game.team_names.first)
    round.start
    round.reload

    participation = Participation.new(team: team, user: user)
    participation.should be_invalid
    participation.errors[:round].first.should eq('must be waiting for players')
  end
end
