class V1::ParticipationsController < ApplicationController
  before_action :authenticate!

  def create
    @round = Round.find(params[:round_id])
    team = @round.find_or_initialize_team(params[:team])
    Participation.create_or_update(team: team, user: current_user, joined: true)

    render json: @round, status: :created
  end

  def destroy
    @round = Round.find(params[:round_id])
    @round.participations.where(user: current_user).first.destroy

    render json: @round
  end
end