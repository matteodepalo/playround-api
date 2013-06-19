if Rails.env.test?
  WebMock.allow_net_connect!
  FACEBOOK_TEST_USERS = Koala::Facebook::TestUsers.new(app_id: ENV['FACEBOOK_APP_ID'], secret: ENV['FACEBOOK_APP_SECRET'])
end

oauth = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'])
FACEBOOK_CLIENT = Koala::Facebook::API.new(oauth.get_app_access_token)
WebMock.disable_net_connect! if Rails.env.test?