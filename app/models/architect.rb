# == Schema Information
#
# Table name: architects
#
#  id                    :integer          not null, primary key
#  name                  :string
#  byline                :string
#  last_name_first       :string
#  firm                  :string
#  description           :text
#  birth                 :string
#  death                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  slug                  :string
#  description_formatted :text
#  photo                 :string
#

class Architect < ApplicationRecord # :nodoc:
  mount_uploader :photo, ImageUploader
  include ImageHelper

  extend FriendlyId
  friendly_id :name, use: :slugged

  default_scope { order(last_name_first: :asc) }

  has_and_belongs_to_many :buildings, join_table: :architects_buildings, optional: true
  before_save :format
  validates :name, presence: true

  def title
    name
  end

  def headline
    return "#{name} (#{birth} - #{death})" if birth
    name
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
