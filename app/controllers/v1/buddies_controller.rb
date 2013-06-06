class V1::BuddiesController < ApplicationController
  before_filter :authenticate!, only: :create
  before_filter :find_user, only: :create

  def index
    authenticate
    request_http_token_authentication and return unless find_user

    render json: @user.buddies
  end

  def create
    authorize! :manage, @user

    @user.buddies_hashes = params[:buddies]

    render json: @user.buddies
  end

  private

  def find_user
    @user = if params[:user_id] == 'me'
      current_user
    else
      User.find(params[:user_id])
    end
  end
end
