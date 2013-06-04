class V1::BuddiesController < ApplicationController
  def index
    @user = User.find(params[:user_id])

    render json: @user.buddies
  end
end
