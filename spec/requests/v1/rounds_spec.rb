require 'spec_helper'

describe 'Rounds Requests' do
  valid_attributes = { game_name: 'dota2' }
  invalid_attributes = { game_name: 'lol' }
  let(:user) { create :user }

  describe 'GET /rounds/1' do
    describe 'with authentication' do
      it 'returns the requested round' do
        round = create :round
        get_with_auth v1_round_path(round), user: round.user

        response.status.should eq(200)
        response.body.should include(round.id.to_s)
        response.body.should include('waiting_for_players')
        response.body.should include('Dota 2')
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
        response.body.should include(round.id.to_s)
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
      it 'succeeds with valid params' do
        game = Game.build_and_create(name: valid_attributes[:game_name])
        post_with_auth v1_rounds_path, { round: valid_attributes }, user: user

        response.status.should eq(201)
        response.body.should include('id')
        response.body.should include('waiting_for_players')
        response.body.should include('Dota 2')
      end

      it 'adds participants to the round' do
        game = Game.build_and_create(name: valid_attributes[:game_name])
        participant = create :user
        valid_attributes.merge!(participant_list: [{ id: participant.id }, { facebook_id: '123' }])
        post_with_auth v1_rounds_path, { round: valid_attributes }, user: user

        response.body.should include(participant.id)
        response.body.should include('123')
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

  describe 'PATCH /rounds/1' do
    describe 'with authentication and authorization' do
      it 'succeeds with valid params' do
        round = create :round
        patch_with_auth v1_round_path(id: round.to_param), { round: valid_attributes }, user: round.user

        response.status.should eq(200)
      end

      it 'fails and responds with unprocessable entity with invalid params' do
        round = create :round
        patch_with_auth v1_round_path(id: round.to_param), { round: invalid_attributes }, user: round.user

        response.status.should eq(422)
        response.body.should include('errors')
      end
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        round = create :round
        patch v1_round_path(id: round.to_param), { round: valid_attributes }

        response.status.should eq(401)
      end
    end

    describe 'without authorization' do
      it 'responds with forbidden' do
        round = create :round
        patch_with_auth v1_round_path(id: round.to_param), { round: valid_attributes }, user: user

        response.status.should eq(403)
      end
    end
  end

  describe 'DELETE /rounds/1' do
    describe 'with authentication and authorization' do
      it 'succeeds with valid params' do
        round = create :round
        delete_with_auth v1_round_path(round), user: round.user

        response.status.should eq(204)
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