class V1::BuddiesController < ApplicationController
  before_filter :authenticate, if: -> { params[:user_id] == 'me' }

  def index
    @user = if params[:user_id] == 'me'
      current_user
    else
      User.find(params[:user_id])
    end

    render json: @user.buddies
  end
end
