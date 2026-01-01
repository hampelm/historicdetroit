class GalleriesController < ApplicationController
  def index
    @galleries = Gallery.all
  end

  def show
    @gallery = Gallery.friendly.find(params[:id])
  end

  def new
    @gallery = Gallery.new
    @buildings = Building.select(:id, :name).all
  end

  def create
    @gallery = Gallery.new(gallery_params)
    @buildings = Building.select(:id, :name).all

    if @gallery.save
      redirect_to @gallery
    else
      render 'new'
    end

  end

  def edit
    @gallery = Gallery.friendly.find(params[:id])
    @buildings = Building.select(:id, :name).all
  end

  def update
    @gallery = Gallery.friendly.find(params[:id])
    @buildings = Building.select(:id, :name).all

    @gallery.update(gallery_params)
    if @gallery.save
      redirect_to @gallery
    else
      render 'edit'
    end
  end

  private

  def gallery_params
    params.require(:gallery).permit(
      :title,
      :description,
      :building_id,
      photos_attributes: %i[id _destroy title caption byline
                            gallery_id photo position]
    )
  end
end
