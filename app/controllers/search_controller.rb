class SearchController < ApplicationController
  def index
    @query = params[:query]
    @buildings = Building.where("description ILIKE ?", "%#{@query}%").or(Building.where("name ILIKE ?", "%#{@query}%")).or(Building.where("address ILIKE ?", "%#{@query}%"))


  end
end
