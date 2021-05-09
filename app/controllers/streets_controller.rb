class StreetsController < ApplicationController
  def index
    @streets = Street.all
    @streets_by_first_letter = @streets.group_by { |s| s.name[0] }
    @streets_by_first_letter = @streets_by_first_letter.sort_by { |key| key }.to_h
  end
end
