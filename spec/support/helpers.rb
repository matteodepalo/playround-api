module Test::Helpers
  ['get', 'post', 'patch', 'delete', 'put'].each do |method|
    define_method method do |path, data = {}, headers = {}|
      super(path, data.to_json, headers.merge(CONTENT_TYPE: 'application/json'))
    end

    define_method "#{method}_with_auth" do |path, data = {}, user: nil|
      send(method, path, data, {
        authorization: ActionController::HttpAuthentication::Token.encode_credentials(user.api_keys.first_or_create.access_token)
      })
    end
  end

  def stub_geocoder
    Geocoder.stub(:search).and_return(EXAMPLE_GEOCODER_RESULT)
  end
end