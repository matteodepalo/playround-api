module Test::Helpers
  ['get', 'post', 'patch', 'delete', 'put'].each do |method|
    define_method "#{method}_with_auth" do |path, data = nil, user: nil|
      send(method, path, data.to_json, {
        authorization: ActionController::HttpAuthentication::Token.encode_credentials(user.api_keys.first_or_create.access_token),
        CONTENT_TYPE: 'application/json'
      })
    end
  end
end