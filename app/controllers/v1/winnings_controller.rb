class V1::WinningsController < ApplicationController
  before_action :authenticate!

  def create
    @round = Round.find(params[:round_id])
    authorize! :declare_winner, @round
    winning = Winning.new(round: @round, team_name: params[:winning][:team_name])

    if winning.save
      render json: { winning: RoundSerializer.new(@round) }, status: :created
    else
      render json: { errors: winning.errors }, status: :unprocessable_entity
    end
  end
end