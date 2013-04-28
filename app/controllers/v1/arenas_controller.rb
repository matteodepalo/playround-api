class V1::ArenasController < ApplicationController
  def index
    respond_with Arena.all
  end

  def show
    respond_with Arena.find(params[:id])
  end
end
