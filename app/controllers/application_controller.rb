class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  include ActionController::HttpAuthentication::Token::ControllerMethods

  respond_to :json
  before_filter :set_format

  protected

  def authenticate
    if user = authenticate_with_http_token { |token, options| User.authenticate(token) }
      @current_user = user
    else
      request_http_token_authentication
    end
  end

  attr_reader :current_user

  private

  def set_format
    request.format = 'json'
  end
end