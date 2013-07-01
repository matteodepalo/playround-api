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

    @user = if params[:user_id] == 'me'
      current_user
    else
      User.find(params[:user_id])
    end

    authorize! :manage, @user
    @user.buddy_list = params[:buddies]

    render json: @user.buddies
  end
end
