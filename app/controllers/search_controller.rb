class SearchController < ApplicationController
  def index
    @query = params[:query]
    @buildings = Building.where("description like ?", "%#{@query}%")
    # Building.search_for(@query)
  end
end
