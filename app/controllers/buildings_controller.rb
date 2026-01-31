class BuildingsController < ApplicationController
  def index
    @buildings = Building.includes(:subjects).all
    
    @buildings = @buildings.without_homes unless params[:subject] == 'homes'

    # Support filtering on parameters
    # Filter by subject
    if params[:subject].present?
      @buildings = @buildings.where(subjects: { slug: params[:subject] })
    end

    # Filter by demolition status
    if params[:status].present?
      if params[:status] == 'exists'
        @buildings = @buildings.exists
      elsif params[:status] == 'demolished'
        @buildings = @buildings.demolished
      end
    end
    
    # Filter by year built range
    if params[:year_built_from].present?
      @buildings = @buildings.where("year_built >= ?", params[:year_built_from])
    end
    if params[:year_built_to].present?
      @buildings = @buildings.where("year_built <= ?", params[:year_built_to])
    end

    @subject_filters = Subject.filters

    fresh_when(@buildings)
  end

  def show
    @building = Building.includes(:subjects, :architects, { galleries: :photos }, :postcards).friendly.find(params[:id])
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
  
  def building_params
    params.permit(:status, :subject, :exists, :year_built_from, :year_built_to)
  end
end