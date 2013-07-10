require 'spec_helper'

describe 'Winnings Requests' do
  let(:round) { create :full_round }

  describe 'POST /rounds/:round_id/winnings' do
    valid_attributes = { winning: { team_name: 'radiant' } }
    describe 'with authentication and authorization' do
      it 'succeeds with valid attributes' do
        post_with_auth v1_round_winnings_path(round), valid_attributes, user: round.user

        response.status.should eq(200)
        round = JSON.parse(response.body)['round']
        round['state'].should eq('over')
        round['teams'].select { |t| t['name'] == 'radiant' }.first['winner'].should eq(true)
      end
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        post v1_round_winnings_path(round), valid_attributes

        response.status.should eq(401)
      end
    end

    describe 'without authorization' do
      it 'responds with forbidden' do
        post_with_auth v1_round_winnings_path(round), valid_attributes, user: create(:user)

        response.status.should eq(403)
      end
    end
  end
end