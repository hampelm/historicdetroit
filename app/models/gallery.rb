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
  friendly_id :title, use: :slugged

  has_many :photos
end
