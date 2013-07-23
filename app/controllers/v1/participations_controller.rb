class V1::ParticipationsController < ApplicationController
  before_action :authenticate!

  def create
    @round = Round.find(params[:round_id])

    if params[:participation]
      team = @round.find_or_initialize_team(params[:participation][:team])
      participation = Participation.new(team: team, user_id: params[:participation][:user][:id])
      authorize! :create, participation

      if participation.save
        render json: { participation: RoundSerializer.new(@round) }, status: :created
      else
        render json: { errors: participation.errors }, status: :unprocessable_entity
      end
    elsif params[:participations]
      params[:participations].each do |p|
        team = @round.find_or_initialize_team(p[:team])
        participation = Participation.new(team: team, user_id: p[:user][:id])
        authorize! :create, participation

        participation.save
      end

      render json: { participations: RoundSerializer.new(@round) }, status: :created
      # ignoring errors for now waiting for batch requests
    else
      head :bad_request
    end
  end

  def destroy
    @round = Round.find(params[:round_id])
    user_id = params[:id]
    participation = @round.participations.where(user_id: user_id).first
    authorize! :destroy, participation
    participation.destroy

    render json: @round
  end
end