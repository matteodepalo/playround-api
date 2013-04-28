class V1::GamesController < ApplicationController
  def index
    respond_with Game.all
  end

  def show
    respond_with Game.find(params[:id])
  end
end