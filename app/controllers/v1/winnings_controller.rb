class V1::WinningsController < ApplicationController
  before_action :authenticate!

  def create
    @round = Round.find(params[:round_id])
    authorize! :declare_winner, @round
    @round.declare_winner(params[:winning][:team_name])

    render json: @round
  end
end