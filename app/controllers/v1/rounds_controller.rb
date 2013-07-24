class V1::RoundsController < ApplicationController
  before_action :authenticate!, except: :index

  def index
    render json: Round.near(params[:latitude], params[:longitude]).order('created_at DESC')
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
      teams: [:name, participations: [user: [:id, :facebook_id]]]
    )
  end
end