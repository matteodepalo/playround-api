require 'spec_helper'

describe 'Users Requests' do
  describe 'GET /users/1' do
    it 'returns the requested user' do
      user = create :user
      get v1_user_path(user)

      response.status.should eq(200)
      response.body.should include(user.id.to_s)
      response.body.should include(user.name)
    end
  end

  describe 'GET /users/me' do
    it 'responds with unauthorized if the access token is not present or invalid' do
      get me_v1_users_path

      response.status.should eq(401)
    end

    it 'returns the current user' do
      user = create :user
      get_with_auth me_v1_users_path, user: user

      response.status.should eq(200)
      response.body.should include(user.id)
    end
  end
end