class V1::UsersController < ApplicationController
  def show
    if params[:id] == 'me'
      request_http_token_authentication and return unless authenticate
      render json: current_user, serializer: CompleteUserSerializer
    else
      render json: User.find(params[:id])
    end
  end
end
