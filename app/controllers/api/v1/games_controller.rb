class Api::V1::GamesController < ApplicationController
  respond_to :json

  def index
    respond_with Game.all
  end

  def show
    respond_with Game.find(params[:id])
  end
end
