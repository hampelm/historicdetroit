# == Schema Information
#
# Table name: galleries
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#

class Gallery < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :photos

  # Needed to get Rails Admin to set the slug
  def slug=(value)
    if value.present?
      write_attribute(:slug, value)
    end
  end
end
