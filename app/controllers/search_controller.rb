class SearchController < ApplicationController
  def index
    @query = params[:query]
    @buildings = Building
      .where("description ILIKE ?", "%#{@query}%")
      .or(Building.where("name ILIKE ?", "%#{@query}%"))
      .or(Building.where("address ILIKE ?", "%#{@query}%"))
      .or(Building.where("also_known_as ILIKE ?", "%#{@query}%"))

  end
end
