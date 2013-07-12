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
end
