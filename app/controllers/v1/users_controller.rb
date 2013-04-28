class V1::UsersController < ApplicationController
  before_filter :authenticate, only: [:me]

  def show
    respond_with User.find(params[:id])
  end

  def me
    respond_with @current_user
  end
end
