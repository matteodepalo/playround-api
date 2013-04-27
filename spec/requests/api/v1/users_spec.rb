require 'spec_helper'

describe 'Users Requests' do
  describe 'GET /users/1' do
    it 'returns the requested user' do
      user = create :user
      get api_v1_user_path(user)
      response.status.should eq(200)
    end
  end
end