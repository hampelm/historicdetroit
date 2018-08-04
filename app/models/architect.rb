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

class Architect < ApplicationRecord # :nodoc:
  extend FriendlyId
  friendly_id :name, use: :slugged

  default_scope { order(last_name_first: :asc) }

  has_one_attached :photo
  has_and_belongs_to_many :buildings, join_table: :architects_buildings
  before_save :format
  validates :name, presence: true

  def title
    name
  end

  def photo?
    photo.attached?
  end

  def thumbnail
    photo.andand.variant(combine_options: {thumbnail: '100x100^', gravity: 'center', extent: '100x100'})
  end

  # Needed to get Rails Admin to set the slug
  def slug=(value)
    write_attribute(:slug, value) if value.present?
  end

  private

  def format
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      space_after_headers: true
    )
    self.description_formatted = markdown.render(description)
  end
end
