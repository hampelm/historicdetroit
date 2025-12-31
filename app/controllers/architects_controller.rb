class ArchitectsController < ApplicationController
  def index
    @architects = Architect.all.sort_by { |a| a.buildings.count }.reverse
  end

  def show
    @architect = Architect.friendly.find(params[:id])
    @buildings = @architect.buildings.distinct
  end
end
