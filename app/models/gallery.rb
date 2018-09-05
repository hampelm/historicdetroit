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
#  building_id :integer
#

class Gallery < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  acts_as_taggable
  attr_accessor :tag_list

  has_many :photos, -> { order(position: :asc) }
  belongs_to :building, optional: true

  # Needed to get Rails Admin to set the slug
  def slug=(value)
    write_attribute(:slug, value) if value.present?
  end
end
