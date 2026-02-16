class GalleriesController < ApplicationController
  before_action :require_admin!, only: [:bulk_upload]

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

  def bulk_upload
    @galleries = Gallery.all
  end

  private

  def require_admin!
    unless admin?
      redirect_to root_path, alert: 'You must be an admin to access this page.'
    end
  end

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
