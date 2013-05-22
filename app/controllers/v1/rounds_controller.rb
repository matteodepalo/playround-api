class V1::RoundsController < ApplicationController
  before_filter :authenticate

  def index
    respond_with Round.where(user_id: current_user.id)
  end

  def show
    @round = Round.find(params[:id])

    respond_with @round
  end

  def create
    @round = Round.new(round_params)

    if @round.save
      render json: @round, status: :created
    else
      render json: { errors: @round.errors }, status: :unprocessable_entity
    end
  end

  def update
    @round = Round.find(params[:id])
    authorize! :update, @round

    if @round.update(round_params)
      render json: @round, status: :ok
    else
      render json: { errors: @round.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @round = Round.find(params[:id])
    authorize! :destroy, @round

    respond_with @round.destroy
  end

  private

  def round_params
    params.require(:round).permit(:game_name)
  end
end