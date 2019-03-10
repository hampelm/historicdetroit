class SearchController < ApplicationController
  def index
    @query = params[:query]
    @buildings = Building.search_for(@query)
  end
end
