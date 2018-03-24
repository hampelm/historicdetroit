# == Schema Information
#
# Table name: galleries
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Gallery < ApplicationRecord
  extend FriendlyId
  has_many :photos
  friendly_id :title, use: :slugged
end
