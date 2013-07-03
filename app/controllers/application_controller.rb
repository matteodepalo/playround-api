class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include CanCan::ControllerAdditions

  rescue_from CanCan::AccessDenied do |exception|
    head :forbidden
  end

  def current_user
    warden.user
  end

  protected

  def warden
    env['warden']
  end

  def authenticate!
    warden.authenticate!
  end
end