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
#  year_built            :string
#  primary_type          :integer
#  last_update           :datetime
#

class Building < ApplicationRecord
  include PgSearch

  pg_search_scope :search_for, against: %i(name description year_opened year_closed year_demolished byline also_known_as)

  mount_uploader :photo, ImageUploader

  extend FriendlyId
  friendly_id :name, use: :slugged

  default_scope { order(name: :asc) }
  scope :with_location, -> { where.not(lat: nil, lat: 0) }
  scope :without_homes, -> { where.not(primary_type: :home) }
  
  scope :exists, -> { where("nullif(year_demolished, '') IS NULL AND status != 'Demolished'") }
  scope :demolished, -> { where("(nullif(year_demolished, '') IS NOT NULL AND year_demolished != '') OR status = 'Demolished'") }

  has_and_belongs_to_many :architects, join_table: :architects_buildings, uniq: true
  has_and_belongs_to_many :posts, join_table: :buildings_posts
  has_and_belongs_to_many :subjects, join_table: :buildings_subjects, uniq: true
  has_and_belongs_to_many :postcards, join_table: :buildings_postcards
  has_many :galleries
  before_save :format
  validates :name, presence: true
  validate :coordinates_must_be_plausible

  enum primary_type: [ :building, :home, :monument, :steamer ]

  def title
    name
  end
  
  def head_title
    name + (also_known_as.present? ? " (#{also_known_as})" : '')
  end

  def coordinates_must_be_plausible
    return if lat.nil? && lng.nil?

    if lat.nil? || lng.nil?
      errors.add(:base, "Both latitude and longitude are needed to place this building on the map, but only one is filled in. You can copy both from Google Maps: right-click the building and click the numbers at the top of the menu (for example 42.3314, -83.0458). The first number is latitude, the second is longitude.")
      return
    end

    in_range = true
    unless lat.between?(-90, 90)
      in_range = false
      errors.add(:base, "Latitude must be a number between -90 and 90, but it is #{lat.to_s('F')}. Latitude is how far north the building is; anywhere in Detroit it's about 42.3. A value this large usually means the decimal point is missing, e.g. 423314 instead of 42.3314.")
    end
    unless lng.between?(-180, 180)
      in_range = false
      errors.add(:base, "Longitude must be a number between -180 and 180, but it is #{lng.to_s('F')}. Longitude is how far east or west the building is; anywhere in Detroit it's about -83.0 (note the minus sign). A value this large usually means the decimal point is missing, e.g. -830458 instead of -83.0458.")
    end
    if in_range && lat.negative? && lng.positive?
      errors.add(:base, "Latitude and longitude look swapped (latitude #{lat.to_s('F')}, longitude #{lng.to_s('F')}). In Detroit, latitude is positive (about 42.3) and longitude is negative (about -83.0).")
    end
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

  def still_exists?
    year_demolished.blank? && status != 'Demolished'
  end

  def subjects_css
    subjects.map { |s| "category-#{s.slug}" }.join(' ') + ' ' + "status-#{status.to_s.parameterize}"
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
