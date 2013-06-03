require 'spec_helper'

describe 'Tokens Requests' do
  describe 'POST /tokens' do
    it 'creates a new user with a Facebook access token', :vcr do
      post v1_tokens_path, { token: { facebook_access_token: 'CAACEdEose0cBABx7PukzIAENOlbNhRcDVY75kgEKjMl3KZAE137e9NGx8rbwqd9ZCrTn5OS2xHoOu1TLFAgBeMzftR1smMra45QlcjGgCS98xzPOZCZCxsD6UrxtMyDBXZAgvenn4hCWwEMvFhZC0xZBZCZBZB1d23ONDGqQhdzEhxpwZDZD' } }

      response.status.should eq(200)
      parsed_response = JSON.parse(response.body)
      parsed_response['token']['value'].should_not be_nil
      user = parsed_response['token']['user']
      user['name'].should eq('Matteo Depalo')
      user['email'].should eq('matteodepalo@gmail.com')
      user['image'].should match(/http:\/\/graph.facebook.com\/.+\/picture\?type=square/)
    end
  end
end