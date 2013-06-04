class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include CanCan::ControllerAdditions

  respond_to :json
  before_filter :set_format

  rescue_from CanCan::AccessDenied do |exception|
    head :forbidden
  end

  protected

  def authenticate
    request_http_token_authentication and return unless authenticate!
  end

  def authenticate!
    @current_user = authenticate_with_http_token { |token, options| User.authenticate(token) }
  end

  attr_reader :current_user

  private

  def set_format
    request.format = 'json'
  end
end