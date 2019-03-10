class BuildingsController < ApplicationController
  def index
    @buildings = Building.without_homes
    fresh_when(@buildings)
  end

  def show
    @building = Building.friendly.find(params[:id])
    fresh_when(@building)
  end

  def map
    buildings = Building.with_location
    @buildings = buildings.map do |building|
      {
        name: building.name,
        url: url_for(building),
        image: building.photo.andand.polaroid.andand.url,
        thumb: building.photo.andand.thumbnail.andand.url,
        lat: building.lat,
        lng: building.lng
      }
    end
  end
end
