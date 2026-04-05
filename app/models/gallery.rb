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
#  published   :boolean
#

class Gallery < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  acts_as_taggable
  attr_accessor :tag_list

  default_scope { order(title: :asc) }

  has_many :photos, -> { order(position: :asc) }, inverse_of: :gallery
  accepts_nested_attributes_for :photos, reject_if: :all_blank, allow_destroy: true

  belongs_to :building, optional: true

  validates :title, presence: true

  before_destroy :remove_attached_photos

  def photo?
    self.photos.first.andand.photo?
  end

  def photo
    self.photos.first.andand.photo
  end

  # Needed to get Rails Admin to set the slug
  def slug=(value)
    write_attribute(:slug, value) if value.present?
  end

  private

  def remove_attached_photos
    self.photos.each do |photo|
      photo.gallery = nil
      photo.save
    end
  end
end
