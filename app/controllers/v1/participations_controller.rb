class V1::ParticipationsController < ApplicationController
  before_filter :authenticate!

  def create
    @round = Round.find(params[:round_id])
    Participation.create_or_update(round: @round, user: current_user, joined: true)

    render json: @round, status: :created
  end

  def destroy
    @round = Round.find(params[:round_id])
    @round.users.destroy(current_user)

    render json: @round
  end
end