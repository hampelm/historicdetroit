# == Schema Information
#
# Table name: subjects
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Subject < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_and_belongs_to_many :postcard, join_table: :postcard_subjects
  has_and_belongs_to_many :buildings, join_table: :building_subjects

  has_one_attached :photo

  # Needed to get Rails Admin to set the slug
  def slug=(value)
    write_attribute(:slug, value) if value.present?
  end
end
