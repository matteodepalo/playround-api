require 'spec_helper'

describe 'Participations Requests' do
  let(:user) { create :user }
  let(:round) { create :round, game_name: :dota2, user: user }

  describe 'POST /v1/round/:round_id/participations' do
    describe 'with authentication and authorization' do
      it 'adds the participation to the round' do
        post_with_auth v1_round_participations_path(round), { participation: { team: 'radiant', user: { id: user.id } } }, user: user

        response.status.should eq(201)
        team = JSON.parse(response.body)['participation']['round']['teams'].select { |t| t['name'] == 'radiant' }.first
        participations = team['participations']
        participations.first['user']['id'].should eq(user.id.to_s)
      end

      it 'adds multiple participations to the round' do
        user2 = create :user

        valid_attributes = {
          participations: [
            { team: 'radiant', user: { id: user.id } },
            { team: 'dire', user: { id: user2.id } }
          ]
        }

        post_with_auth v1_round_participations_path(round), valid_attributes, user: user

        response.status.should eq(201)
        teams = JSON.parse(response.body)['participations']['round']['teams']
        all_participations = teams.map { |t| t['participations'] }.flatten
        all_participations.count.should eq(2)
        team1 = teams.select { |t| t['name'] == 'radiant' }.first
        team1_participations = team1['participations']
        team1_participations.first['user']['id'].should eq(user.id.to_s)
        team2 = teams.select { |t| t['name'] == 'dire' }.first
        team2_participations = team2['participations']
        team2_participations.first['user']['id'].should eq(user2.id.to_s)
      end
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        post v1_round_participations_path(round)

        response.status.should eq(401)
      end
    end

    describe 'without authorization' do
      it 'responds with forbidden' do
        post_with_auth v1_round_participations_path(round), { participation: { team: 'radiant', user: { id: user.id } } }, user: create(:user)

        response.status.should eq(403)
      end
    end

    describe 'with invalid params' do
      it 'responds with bad request' do
        post_with_auth v1_round_participations_path(round), { wrong_parameter: { team: 'radiant', user: { id: user.id } } }, user: user

        response.status.should eq(400)
      end
    end
  end

  describe 'DELETE /v1/round/:round_id/participations' do
    describe 'with authentication' do
      it 'removes the participation from the round' do
        Participation.create(team: round.teams.create(name: round.game.team_names.first), user: user)
        delete_with_auth v1_round_participation_path(round, user), {}, user: user

        response.status.should eq(200)
        JSON.parse(response.body)['round']['teams'].map { |t| t['participations'] }.flatten.should eq([])
      end
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        delete v1_round_participation_path(round, user)

        response.status.should eq(401)
      end
    end

    describe 'without authorizaiton' do
      it 'responds with forbidden' do
        Participation.create(team: round.teams.create(name: round.game.team_names.first), user: user)
        delete_with_auth v1_round_participation_path(round, user), {}, user: create(:user)

        response.status.should eq(403)
      end
    end
  end
end
