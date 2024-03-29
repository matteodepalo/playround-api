require 'spec_helper'

describe 'Starts Requests' do
  let(:round) { create :round }

  describe 'POST /v1/rounds/{round_id}/starts' do
    describe 'with authentication and authorization' do
      it 'succeeds' do
        post_with_auth v1_round_starts_path(round), {}, user: round.user

        response.status.should eq(201)
        round = JSON.parse(response.body)['start']['round']
        round['state'].should eq('ongoing')
      end
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        post v1_round_starts_path(round), { }

        response.status.should eq(401)
      end
    end

    describe 'without authorization' do
      it 'responds with forbidden' do
        post_with_auth v1_round_starts_path(round), {}, user: create(:user)

        response.status.should eq(403)
      end
    end
  end
end