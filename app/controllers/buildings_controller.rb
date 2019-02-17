class BuildingsController < ApplicationController
  def index
    @buildings = Building.without_homes
    fresh_when(@buildings)
  end

  def show
    @building = Building.friendly.find(params[:id])
    fresh_when(@building)
  end
end
