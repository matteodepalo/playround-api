class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::ImplicitRender

  respond_to :json
  before_filter :set_format

  private

  def set_format
    request.format = 'json'
  end
end