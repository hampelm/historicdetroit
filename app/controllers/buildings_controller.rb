class BuildingsController < ApplicationController
  def index
    @buildings = Building.all
  end

  def show
    @building = Building.friendly.find(params[:id])
  end
end
