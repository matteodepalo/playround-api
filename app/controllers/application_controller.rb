class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include CanCan::ControllerAdditions

  rescue_from CanCan::AccessDenied do |exception|
    head :forbidden
  end

  protected

  def authenticate!
    request_http_token_authentication and return unless authenticate
  end

  def authenticate
    @current_user ||= authenticate_with_http_token { |token, options| User.authenticate(token) }
  end

  attr_reader :current_user
end