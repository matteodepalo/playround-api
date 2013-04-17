class Api::V1::RoundsController < ApplicationController
  respond_to :json

  def index
    respond_with Round.all
  end

  def show
    respond_with Round.find(params[:id])
  end

  def create
    respond_with Round.create(params[:entry])
  end

  def update
    respond_with Round.update(params[:id], params[:entry])
  end

  def destroy
    respond_with Round.destroy(params[:id])
  end
end