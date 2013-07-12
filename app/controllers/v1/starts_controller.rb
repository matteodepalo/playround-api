class V1::StartsController < ApplicationController
  before_action :authenticate!

  def create
    @round = Round.find(params[:round_id])
    authorize! :start, @round
    @round.start

    render json: { start: RoundSerializer.new(@round) }, status: :created
  end
end