require 'redcarpet' # Markdown
# == Schema Information
#
# Table name: posts
#
#  id             :integer          not null, primary key
#  title          :string
#  body           :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  slug           :string
#  body_formatted :text
#  date           :datetime
#  photo          :string
#

class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  before_save :format
  mount_uploader :photo, ImageUploader

  has_and_belongs_to_many :buildings, join_table: :buildings_posts

  scope :future, -> {
    where('date <= ?', Time.now).order(date: :desc)
  }

  def date_formatted
    date.strftime("%b. %-d, %Y")
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
    self.body_formatted = markdown.render(body)
  end
end
