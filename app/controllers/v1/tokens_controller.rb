class V1::TokensController < ApplicationController
  def create
    graph = Koala::Facebook::API.new(params[:facebook_access_token])
    info = graph.get_object('me')
    @user = User.find_or_create_by_facebook_oauth(info)

    respond_with @user.api_keys.create
  end
end
