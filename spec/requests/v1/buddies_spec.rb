require 'spec_helper'

describe 'Buddies Requests' do
  let(:user) { create :user }

  describe 'GET /v1/users/:user_id/buddies' do
    it 'responds with the list of buddies' do
      3.times { user.buddies << create(:user) }
      get v1_user_buddies_path(user)

      response.status.should eq(200)
      JSON.parse(response.body)['buddies'].count.should eq(3)
    end
  end

  describe 'GET /v1/users/me/buddies' do
    it 'responds with the list of current_user\'s buddies' do
      3.times { user.buddies << create(:user) }
      get_with_auth v1_user_buddies_path(user_id: 'me'), user: user

      response.status.should eq(200)
      JSON.parse(response.body)['buddies'].count.should eq(3)
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        3.times { user.buddies << create(:user) }
        get v1_user_buddies_path(user_id: 'me')

        response.status.should eq(401)
      end
    end
  end
end