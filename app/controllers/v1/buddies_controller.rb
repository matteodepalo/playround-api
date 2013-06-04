class V1::BuddiesController < ApplicationController
  before_filter :authenticate, if: -> { params[:user_id] == 'me' }

  def index
    if params[:user_id] == 'me'
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end

    render json: @user.buddies
  end
end
