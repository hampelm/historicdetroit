class StreetsController < ApplicationController
  def index
    @streets = Street.all
  end
end
