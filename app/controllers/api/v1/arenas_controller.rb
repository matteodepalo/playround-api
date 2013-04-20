class Api::V1::ArenasController < ApplicationController
  respond_to :json

  def index
    respond_with Arena.all
  end

  def show
    respond_with Arena.find(params[:id])
  end
end
