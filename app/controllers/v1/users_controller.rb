class V1::UsersController < ApplicationController
  before_filter :authenticate, if: -> { params[:id] == 'me' }

  def show
    if params[:id] == 'me'
      render json: current_user, serializer: CompleteUserSerializer
    else
      render json: User.find(params[:id])
    end
  end
end
