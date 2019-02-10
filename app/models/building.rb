require 'open-uri'
require 'redcarpet' # Markdown
require 'uri'

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
#  photo                 :string
#

class Building < ApplicationRecord
  mount_uploader :photo, ImageUploader

  extend FriendlyId
  friendly_id :name, use: :slugged

  default_scope { order(name: :asc) }

  has_and_belongs_to_many :architects, join_table: :architects_buildings, uniq: true
  has_and_belongs_to_many :posts, join_table: :buildings_posts
  has_and_belongs_to_many :subjects, join_table: :buildings_subjects, uniq: true
  has_and_belongs_to_many :postcards, join_table: :buildings_postcards
  has_many :galleries
  before_save :format
  validates :name, presence: true

  def self.without_homes
    # TODO -- this is probably pretty slow
    subject = Subject.find_by(slug: 'homes')
    buildings = Building.all
    return buildings unless subject
    buildings.reject { |b| b.subjects.include? subject }
  end

  def title
    name
  end

  def location?
    !(lat.zero? && lng.zero?)
  end

  def geocode
    mapbox = Rails.configuration.general['mapbox']
    path = "https://api.mapbox.com/geocoding/v5/mapbox.places/#{URI.encode(address)}.json?limit=2&access_token=#{mapbox}"
    results = JSON.load(open(path))
  end

  def latlng
    geocode unless location?
    "#{lat},#{lng}"
  end

  # Needed to get Rails Admin to set the slug
  def slug=(value)
    write_attribute(:slug, value) if value.present?
  end

  def status_enum
    [[nil], ['Open'], ['Closed'], ['Demolished'], ['Under renovation']]
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
