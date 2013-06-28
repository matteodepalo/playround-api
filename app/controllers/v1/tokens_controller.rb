class V1::TokensController < ApplicationController
  def create
    graph = Koala::Facebook::API.new(params[:token][:facebook_access_token])
    info = graph.get_object('me')
    @user = User.find_or_create_by_facebook_oauth(info)

    render json: @user.api_keys.create
  end
end
