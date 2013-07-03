class V1::UsersController < ApplicationController
  def show
    if params[:id] == 'me'
      authenticate!
      render json: current_user, serializer: CompleteUserSerializer
    else
      render json: User.find(params[:id])
    end
  end
end
