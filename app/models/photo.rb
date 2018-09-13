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
#

class Photo < ApplicationRecord
  has_one_attached :photo
  belongs_to :gallery, optional: true
  acts_as_list scope: :gallery

  def polaroid
    photo.andand.variant(combine_options: {thumbnail: '218x200^', gravity: 'center', extent: '218x200'}) if photo.attachment
  end

  def full
    photo.andand.variant(combine_options: {gravity: 'center', extent: '1200x'}) if photo.attachment
  end

  def mobile
    # http://www.imagemagick.org/script/command-line-processing.php#geometry
    photo.andand.variant(combine_options: {gravity: 'center', extent: '600x'}) if photo.attachment
  end
end
