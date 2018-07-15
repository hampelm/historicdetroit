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
#

class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_one_attached :photo

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
