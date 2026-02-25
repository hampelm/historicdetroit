class PhotosController < ApplicationController
  before_action :require_admin!
  before_action :set_gallery

  def create
    # Calculate position: continue from the last photo in this gallery
    max_position = @gallery.photos.maximum(:position) || 0
    
    @photo = @gallery.photos.build(photo_params)
    @photo.position = max_position + 1

    if @photo.save
      render json: {
        success: true,
        photo: {
          id: @photo.id,
          title: @photo.title,
          caption: @photo.caption,
          position: @photo.position,
          thumbnail_url: @photo.photo.thumbnail.url
        }
      }, status: :created
    else
      render json: {
        success: false,
        errors: @photo.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def require_admin!
    unless admin?
      redirect_to root_path, alert: 'You must be an admin to access this page.'
    end
  end

  def set_gallery
    @gallery = Gallery.friendly.find(params[:gallery_id])
  end

  def photo_params
    params.require(:photo).permit(:photo, :title, :caption, :byline)
  end
end
