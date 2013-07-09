require 'spec_helper'

describe 'Participations Spec' do
  let(:user) { create :user }
  let(:round) { create :round, game_name: 'dota2' }

  describe 'POST /round/1/participations' do
    describe 'with authentication' do
      it 'adds the current user to the list of participants' do
        post_with_auth v1_round_participations_path(round), { team: 'radiant' }, user: user

        response.status.should eq(201)
        participations = JSON.parse(response.body)['round']['teams'].map { |t| t['participations'] }.flatten
        participations.first['user']['id'].should eq(user.id.to_s)
        participations.first['joined'].should eq(true)
      end

      it 'updates the current user preexisting participation setting joined to true' do
        Participation.create(team: round.teams.create(name: round.game.team_names.first), user: user)
        post_with_auth v1_round_participations_path(round), {}, user: user

        participations = JSON.parse(response.body)['round']['teams'].map { |t| t['participations'] }.flatten
        participations.to_s.should include(user.id.to_s)
        participations.first['joined'].should eq(true)
      end
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        post v1_round_participations_path(round)

        response.status.should eq(401)
      end
    end
  end

  describe 'DELETE /round/1/participations' do
    describe 'with authentication' do
      it 'removes the current user from the list of participants' do
        Participation.create(team: round.teams.create(name: round.game.team_names.first), user: user)
        delete_with_auth v1_round_participations_path(round), {}, user: user

        response.status.should eq(200)
        JSON.parse(response.body)['round']['teams'].map { |t| t['participations'] }.flatten.should eq([])
      end
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        delete v1_round_participations_path(round)

        response.status.should eq(401)
      end
    end
  end
end
