class V1::ArenasController < ApplicationController
  def index
    render json: Arena.all
  end

  def show
    render json: Arena.find(params[:id])
  end
end
