require 'redcarpet'

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
#

class Building < ApplicationRecord
  before_save :format
  validates :name, presence: true
  
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
