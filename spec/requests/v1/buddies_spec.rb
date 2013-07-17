require 'spec_helper'

describe 'Buddies Requests' do
  describe 'GET users/1/buddies' do
    it 'responds with the list of buddies' do
      user = create :user
      3.times { user.buddies << create(:user) }
      get v1_user_buddies_path(user)

      response.status.should eq(200)
      JSON.parse(response.body)['buddies'].count.should eq(3)
    end
  end

  describe 'GET users/me/buddies' do
    it 'responds with the list of current_user\'s buddies' do
      user = create :user
      3.times { user.buddies << create(:user) }
      get_with_auth v1_user_buddies_path(user_id: 'me'), user: user

      response.status.should eq(200)
      JSON.parse(response.body)['buddies'].count.should eq(3)
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        user = create :user
        3.times { user.buddies << create(:user) }
        get v1_user_buddies_path(user_id: 'me')

        response.status.should eq(401)
      end
    end
  end
end