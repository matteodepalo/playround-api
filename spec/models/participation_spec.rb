# == Schema Information
#
# Table name: participations
#
#  id         :uuid             not null, primary key
#  team       :string(255)
#  round_id   :uuid
#  user_id    :uuid
#  joined     :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_participations_on_round_id  (round_id)
#  index_participations_on_user_id   (user_id)
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
    Participation.new(team: team, user: user).should_not be_valid
  end

  it 'must have a unique combination of user and round' do
    team = round.teams.create(name: round.game.team_names.first)
    team2 = round.teams.create(name: round.game.team_names.last)
    Participation.create(team: team, user: user)
    participation = Participation.new(team: team2, user: user)

    participation.should be_invalid
    participation.errors.full_messages.should include('user and round must be unique')
  end

  describe '#self.create_or_update' do
    it 'creates a participation' do
      team = round.teams.create(name: round.game.team_names.first)
      participation = Participation.create_or_update(team: team, user: user)

      round.participations.should include(participation)
    end

    it 'updates a participation if it already exists' do
      team = round.teams.create(name: round.game.team_names.first)
      participation = create :participation, team: team, user: user
      updated_participation = Participation.create_or_update(team: team, user: user, joined: true)

      participation.joined.should eq(false)
      participation.id.should eq(updated_participation.id)
      updated_participation.joined.should eq(true)
    end
  end
end
