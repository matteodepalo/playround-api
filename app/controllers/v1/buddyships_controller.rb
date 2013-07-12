class V1::BuddyshipsController < ApplicationController
  def create
    authenticate!
    current_user.buddy_list = params[:buddyships]

    render json: current_user.buddyships, status: :created
  end
end
