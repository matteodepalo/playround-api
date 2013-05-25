class V1::ParticipantsController < ApplicationController
  before_filter :authenticate

  def create
    @round = Round.find(params[:round_id])
    @round.users << current_user

    render json: @round, status: :created
  end

  def destroy
    @round = Round.find(params[:round_id])
    @round.users.destroy(current_user)

    render json: @round
  end
end