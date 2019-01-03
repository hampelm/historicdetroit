class ArchitectsController < ApplicationController
  def index
    @architects = Architect.all
  end

  def show
    @architect = Architect.friendly.find(params[:id])
    @buildings = @architect.buildings
  end
end
