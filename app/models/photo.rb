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
end
