# == Schema Information
#
# Table name: architects
#
#  id              :integer          not null, primary key
#  name            :string
#  byline          :string
#  last_name_first :string
#  firm            :string
#  description     :text
#  birth           :string
#  death           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slug            :string
#

class Architect < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_one_attached :photo
  has_and_belongs_to_many :buildings, join_table: :architects_buildings

  def title
    name
  end

  # Needed to get Rails Admin to set the slug
  def slug=(value)
    if value.present?
      write_attribute(:slug, value)
    end
  end
end
