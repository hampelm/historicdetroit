class ArchitectsController < ApplicationController
  def index
    @architects = Architect.all.includes(:buildings).sort_by { |a| a.buildings.size }.reverse
  end

  def show
    @architect = Architect.friendly.find(params[:id])
    @buildings = @architect.buildings.distinct
  end
end
