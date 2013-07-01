Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :token
  manager.failure_app = -> (env) {
    Rack::Response.new(
      [JSON.pretty_generate({ error: env['warden'].message })],
      401,
      'Content-Type' => 'application/json',
      'WWW-Authenticate' => %(Basic realm="API")
    )
  }
end

Warden::Strategies.add(:token) do
  def authenticate!
    token = ActionController::HttpAuthentication::Token.token_and_options(request)
    user = User.authenticate(token)

    if user
      success!(user)
    else
      message = token ? "Invalid Token provided: #{token}" : 'You did not provide a Token.'
      fail message
    end
  end

  def request
    return @request if @request
    if defined?(ActionDispatch::Request)
      @request = ActionDispatch::Request.new(env)
    elsif env['action_controller.rescue.request']
      @request = env['action_controller.rescue.request']
    else
      Rack::Request.new(env)
    end
  end
end