# == Schema Information
#
# Table name: subjects
#
#  id            :integer          not null, primary key
#  title         :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  slug          :string
#  photo         :string
#  use_as_filter :boolean
#

class Subject < ApplicationRecord
  mount_uploader :photo, ImageUploader

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_and_belongs_to_many :postcards, join_table: :postcards_subjects
  has_and_belongs_to_many :buildings, join_table: :buildings_subjects

  default_scope { order(title: :asc) }
  scope :filters, -> { where(use_as_filter: :true).order(title: :asc) }

  def photo?
    photo.file
  end

  # Needed to get Rails Admin to set the slug
  def slug=(value)
    write_attribute(:slug, value) if value.present?
  end
end
