class Api::V1::UsersController < ApplicationController
  def show
    respond_with User.find(params[:id])
  end
end
