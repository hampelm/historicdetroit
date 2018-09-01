require 'redcarpet' # Markdown
# == Schema Information
#
# Table name: buildings
#
#  id                    :integer          not null, primary key
#  name                  :string
#  also_known_as         :string
#  byline                :string
#  description           :text
#  address               :string
#  status                :string
#  style                 :string
#  year_opened           :string
#  year_closed           :string
#  year_demolished       :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  architect_id          :integer
#  description_formatted :text
#  slug                  :string
#  lat                   :decimal(, )
#  lng                   :decimal(, )
#

class Building < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  default_scope { order(name: :asc) }

  has_one_attached :photo
  has_and_belongs_to_many :architects, join_table: :architects_buildings
  has_and_belongs_to_many :posts, join_table: :building_posts
  has_many :galleries
  before_save :format
  validates :name, presence: true

  def title
    name
  end

  # Needed to get Rails Admin to set the slug
  def slug=(value)
    write_attribute(:slug, value) if value.present?
  end

  def status_enum
    [[nil], ['Open'], ['Closed'], ['Demolished'], ['Under renovation']]
  end

  def polaroid
    photo.andand.variant(combine_options: {thumbnail: '218x200^', gravity: 'center', extent: '218x200'})
  end

  def sidebar_photo
    photo.andand.variant(combine_options: {thumbnail: 'x300^', gravity: 'center', extent: '300'})
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
