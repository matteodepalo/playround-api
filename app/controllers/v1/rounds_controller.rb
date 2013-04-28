class V1::RoundsController < ApplicationController
  def index
    respond_with Round.all
  end

  def show
    respond_with Round.find(params[:id])
  end

  def create
    respond_with(:v1, Round.create(round_params))
  end

  def update
    @round = Round.find(params[:id])

    respond_with @round.update(round_params)
  end

  def destroy
    @round = Round.find(params[:id])

    respond_with @round.destroy
  end

  private

  def round_params
    params.permit(:round)
  end
end