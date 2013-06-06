require 'spec_helper'

describe 'Tokens Requests' do
  describe 'POST /tokens' do
    it 'creates a new user with a Facebook access token', :vcr do
      test_users = Koala::Facebook::TestUsers.new(app_id: ENV['FACEBOOK_APP_ID'], secret: ENV['FACEBOOK_APP_SECRET'])
      user = test_users.create(true, 'email')

      post v1_tokens_path, { token: { facebook_access_token: user['access_token'] } }

      response.status.should eq(200)
      parsed_response = JSON.parse(response.body)
      parsed_response['token']['value'].should_not be_nil
      user = parsed_response['token']['user']
      user['name'].should be_present
      user['email'].should be_present
      user['image'].should eq("http://graph.facebook.com/#{user['facebook_id']}/picture?type=square")
      user['facebook_id'].should be_present

      test_users.delete_all
    end
  end
end