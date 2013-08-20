require 'spec_helper'

describe 'Users Requests' do
  describe 'GET /v1/users/{id}' do
    it 'returns the requested user' do
      user_factory = create :user, name: 'Test User', email: 'test@user.com'
      get v1_user_path(user_factory)

      response.status.should eq(200)
      user = JSON.parse(response.body)['user']
      user['id'].should eq(user_factory.id.to_s)
      user['name'].should eq('Test User')
      user['email'].should be_nil
    end
  end

  describe 'GET /v1/users/me' do
    describe 'with authentication' do
      it 'returns the current user' do
        user_factory = create :user, name: 'Test User', email: 'test@user.com'
        get_with_auth v1_user_path(id: 'me'), user: user_factory

        response.status.should eq(200)
        user = JSON.parse(response.body)['user']
        user['id'].should eq(user_factory.id.to_s)
        user['name'].should eq('Test User')
        user['email'].should eq('test@user.com')
      end
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        get v1_user_path(id: 'me')

        response.status.should eq(401)
      end
    end
  end
end