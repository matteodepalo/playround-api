class V1::BuddiesController < ApplicationController
  def index
    @user = if params[:user_id] == 'me'
      authenticate!
      current_user
    else
      User.find(params[:user_id])
    end

    render json: @user.buddies
  end

  def create
    authenticate!
    current_user.buddy_list = params[:buddies]

    render json: current_user.buddies
  end
end
