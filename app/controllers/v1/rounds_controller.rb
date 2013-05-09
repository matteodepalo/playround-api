class V1::RoundsController < ApplicationController
  before_filter :authenticate

  def index
    respond_with Round.where(user_id: current_user.id)
  end

  def show
    @round = Round.find(params[:id])
    authorize! :read, @round

    respond_with @round
  end

  def create
    respond_with [:v1, Round.create(round_params)]
  end

  def update
    @round = Round.find(params[:id])
    authorize! :update, @round

    respond_with @round.update(round_params)
  end

  def destroy
    @round = Round.find(params[:id])
    authorize! :destroy, @round

    respond_with @round.destroy
  end

  private

  def round_params
    params.permit(:round)
  end
end