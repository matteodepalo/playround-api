require 'spec_helper'

describe 'Participations Spec' do
  let(:user) { create :user }
  let(:round) { create :round }

  describe 'POST /round/1/participations' do
    describe 'with authentication' do
      it 'adds the current user to the list of participants' do
        post_with_auth v1_round_participations_path(round), {}, user: user

        response.status.should eq(201)
        participant_list = JSON.parse(response.body)['round']['participations']
        participant_list.to_s.should include(user.id.to_s)
        participant_list.first['joined'].should eq(true)
      end

      it 'updates the current user preexisting participation setting joined to true' do
        round.users << user
        post_with_auth v1_round_participations_path(round), {}, user: user

        participant_list = JSON.parse(response.body)['round']['participations']
        participant_list.to_s.should include(user.id.to_s)
        participant_list.first['joined'].should eq(true)
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
        round.users << user
        delete_with_auth v1_round_participations_path(round), {}, user: user

        response.status.should eq(200)
        JSON.parse(response.body)['round']['participant_list'].to_s.should_not include(user.id.to_s)
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
