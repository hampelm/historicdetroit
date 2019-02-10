class BuildingsController < ApplicationController
  def index
    @buildings = Building.without_homes
  end

  def show
    @building = Building.friendly.find(params[:id])
  end
end
