class V1::StartsController < ApplicationController
  before_action :authenticate!

  def create
    @round = Round.find(params[:round_id])
    authorize! :start, @round
    @round.start

    render json: @round
  end
end