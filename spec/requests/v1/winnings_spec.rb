require 'spec_helper'

describe 'Winnings Requests' do
  let(:round) { create :full_round }

  describe 'POST /v1/rounds/:round_id/winnings' do
    valid_attributes = { winning: { team_name: 'radiant' } }
    invalid_attributes = { winning: { team_name: 'lol' } }

    describe 'with authentication and authorization' do
      it 'succeeds with valid attributes' do
        post_with_auth v1_round_winnings_path(round), valid_attributes, user: round.user

        response.status.should eq(201)
        round = JSON.parse(response.body)['winning']['round']
        round['state'].should eq('over')
        round['teams'].select { |t| t['name'] == 'radiant' }.first['winner'].should eq(true)
      end

       it 'fails and responds with unprocessable entity with invalid params' do
        post_with_auth v1_round_winnings_path(round), invalid_attributes, user: round.user

        response.status.should eq(422)
        response.body.should include('errors')
      end

      it 'fails and responds with unprocessable entity when the round is not ongoing' do
        round = create :round
        post_with_auth v1_round_winnings_path(round), valid_attributes, user: round.user

        response.status.should eq(422)
        response.body.should include('errors')
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