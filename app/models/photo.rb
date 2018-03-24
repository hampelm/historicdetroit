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
  belongs_to :gallery
end
