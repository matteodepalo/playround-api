require 'spec_helper'

describe 'Rounds Requests' do
  valid_attributes = { game_name: 'dota2', arena_properties: { foursquare_id: '5104' } }
  valid_attributes_with_current_location = { game_name: 'dota2', arena_properties: { latitude: 50, longitude: -30 } }
  invalid_attributes = { game_name: 'lol' }
  let(:user) { create :user }

  describe 'GET /rounds/1' do
    describe 'with authentication' do
      it 'returns the requested round' do
        round_factory = create :round
        get_with_auth v1_round_path(round_factory), user: round_factory.user

        response.status.should eq(200)
        round = JSON.parse(response.body)['round']
        round['id'].should eq(round_factory.id.to_s)
        round['state'].should eq('waiting_for_players')
        round['game']['display_name'].should eq('Dota 2')
      end
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        round = create :round
        get v1_round_path(round)

        response.status.should eq(401)
      end
    end
  end

  describe 'GET /rounds' do
    describe 'with authentication' do
      it 'returns the list of rounds owned by the user' do
        round = create :round
        get_with_auth v1_rounds_path, user: round.user

        response.status.should eq(200)
        JSON.parse(response.body)['rounds'].count.should eq(1)
      end
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        round = create :round
        get v1_rounds_path

        response.status.should eq(401)
      end
    end
  end

  describe 'POST /rounds' do
    describe 'with authentication' do
      it 'succeeds with valid params', :vcr do
        game = Game.build_and_create(name: valid_attributes[:game_name])
        post_with_auth v1_rounds_path, { round: valid_attributes }, user: user

        response.status.should eq(201)
        round = JSON.parse(response.body)['round']
        round['id'].should be_present
        round['state'].should eq('waiting_for_players')
        round['game']['display_name'].should eq('Dota 2')
        round['arena']['foursquare_id'].should eq(valid_attributes[:arena_properties][:foursquare_id])
      end

      it 'succeds with valid params with custom location' do
        game = Game.build_and_create(name: valid_attributes[:game_name])
        post_with_auth v1_rounds_path, { round: valid_attributes_with_current_location }, user: user

        response.status.should eq(201)
        round = JSON.parse(response.body)['round']
        round['arena']['latitude'].should eq(valid_attributes_with_current_location[:arena_properties][:latitude])
        round['arena']['longitude'].should eq(valid_attributes_with_current_location[:arena_properties][:longitude])
      end

      it 'adds participants to the round', :vcr do
        game = Game.build_and_create(name: valid_attributes[:game_name])
        participant = create :user

        valid_attributes.merge!(participation_list: [
          { team: 'dire', user: { id: participant.id } },
          { user: { facebook_id: MATTEO_DEPALO['id'] }}
        ])

        post_with_auth v1_rounds_path, { round: valid_attributes }, user: user

        participations = JSON.parse(response.body)['round']['participations']
        participations.count.should eq(2)
        registered_user_participation = participations.first
        facebook_user_participation = participations.last
        registered_user_participation['user']['id'].should eq(participant.id)
        registered_user_participation['team'].should eq('dire')
        facebook_user_participation['user']['facebook_id'].should eq(MATTEO_DEPALO['id'])
        facebook_user_participation['user']['id'].should be_present
        facebook_user_participation['team'].should eq('radiant')
      end

      it 'fails and responds with unprocessable entity with invalid params' do
        post_with_auth v1_rounds_path, { round: invalid_attributes }, user: user

        response.status.should eq(422)
        response.body.should include('errors')
      end
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        post v1_rounds_path, { round: valid_attributes }

        response.status.should eq(401)
      end
    end
  end

  describe 'DELETE /rounds/1' do
    describe 'with authentication and authorization' do
      it 'succeeds with valid params' do
        round = create :round
        delete_with_auth v1_round_path(round), user: round.user

        response.status.should eq(200)
        JSON.parse(response.body)['round']['id'].should eq(round.id)
      end
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        round = create :round
        delete v1_round_path(round)

        response.status.should eq(401)
      end
    end

    describe 'without authorization' do
      it 'responds with forbidden' do
        round = create :round
        delete_with_auth v1_round_path(round), user: user

        response.status.should eq(403)
      end
    end
  end
end