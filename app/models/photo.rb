# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  title      :string
#  caption    :text
#  byline     :string
#  gallery_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  position   :integer
#  photo      :string
#

class Photo < ApplicationRecord
  mount_uploader :photo, ImageUploader

  belongs_to :gallery, optional: true
  acts_as_list scope: :gallery

  # Save image dimensions after upload
  after_save :store_dimensions, if: :saved_change_to_photo?

  # Calculate aspect ratio for justified gallery layout
  def aspect_ratio
    return 1.0 unless image_width.present? && image_height.present? && image_height > 0
    image_width.to_f / image_height.to_f
  end

  private

  def store_dimensions
    return unless photo.present? && photo.file.present?

    begin
      img = MiniMagick::Image.open(photo.path)
      update_columns(image_width: img.width, image_height: img.height)
    rescue => e
      Rails.logger.warn "Could not read image dimensions for Photo #{id}: #{e.message}"
    end
  end
end
