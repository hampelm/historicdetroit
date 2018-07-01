require 'redcarpet' # Markdown

class Page < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  before_save :format

  # Needed to get Rails Admin to set the slug
  def slug=(value)
    write_attribute(:slug, value) if value.present?
  end

  def format
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      space_after_headers: true
    )
    self.body_formatted = markdown.render(body)
  end
end
