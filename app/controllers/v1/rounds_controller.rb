class V1::RoundsController < ApplicationController
  before_filter :authenticate!

  def index
    render json: Round.where(user_id: current_user.id)
  end

  def show
    @round = Round.find(params[:id])

    render json: @round
  end

  def create
    @round = current_user.hosted_rounds.build(round_params)

    if @round.save
      render json: @round, status: :created
    else
      render json: { errors: @round.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @round = Round.find(params[:id])
    authorize! :destroy, @round

    render json: @round.destroy
  end

  private

  def round_params
    params.require(:round).permit(
      :game_name,
      arena: [:foursquare_id, :latitude, :longitude],
      teams: [:name, users: [:id, :facebook_id]]
    )
  end
end