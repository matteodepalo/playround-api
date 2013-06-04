require 'spec_helper'

describe 'Tokens Requests' do
  token = 'CAACEdEose0cBAHslAjv0ct7rRwj4UsZC947J9ONf0o4zZARr3jN7ea1IQ8J5OsLI2l6cfVtnxS3gX2WjK2V5b2khyuwqnsWE11FGQNdDJ9cQI3gKWHxZADZB2ekZCrTVilWgYXR3aBQY5lUfgvqXRDxdnc8LHrr14Qsg9F0pUhgZDZD'

  describe 'POST /tokens', :vcr do
    it 'creates a new user with a Facebook access token' do
      post v1_tokens_path, { token: { facebook_access_token: token } }

      response.status.should eq(200)
      parsed_response = JSON.parse(response.body)
      parsed_response['token']['value'].should_not be_nil
      user = parsed_response['token']['user']
      user['name'].should eq('Matteo Depalo')
      user['email'].should eq('matteodepalo@gmail.com')
      user['image'].should eq("http://graph.facebook.com/#{user['facebook_id']}/picture?type=square")
      user['facebook_id'].should_not be_nil
    end
  end
end