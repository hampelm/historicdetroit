# == Schema Information
#
# Table name: subjects
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#  photo       :string
#

class Subject < ApplicationRecord
  mount_uploader :photo, ImageUploader
  include ImageHelper

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_and_belongs_to_many :postcards, join_table: :postcards_subjects
  has_and_belongs_to_many :buildings, join_table: :buildings_subjects

  # Needed to get Rails Admin to set the slug
  def slug=(value)
    write_attribute(:slug, value) if value.present?
  end
end
