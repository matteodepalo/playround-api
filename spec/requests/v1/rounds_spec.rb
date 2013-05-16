require 'spec_helper'

describe 'Rounds Requests' do
  valid_attributes = {}
  let(:user) { create :user }

  describe 'GET /rounds/1' do
    describe 'with authentication' do
      it 'returns the requested round' do
        round = create :round
        get_with_auth v1_round_path(round), user: round.user

        response.status.should eq(200)
        response.body.should include(round.id.to_s)
        response.body.should include(round.state)
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
        post_with_auth v1_rounds_path, { round: valid_attributes }, user: user

        response.status.should eq(201)
      end

      it 'fails and responds with unprocessable entity with invalid params' do
        post_with_auth v1_rounds_path, { round: {} }, user: user

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

        response.status.should eq(204)
      end

      it 'fails and responds with unprocessable entity with invalid params' do
        round = create :round
        patch_with_auth v1_round_path(id: round.to_param), { round: {} }, user: round.user

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