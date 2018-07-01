# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string
#  body       :text
#  date       :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_one_attached :photo

  # Needed to get Rails Admin to set the slug
  def slug=(value)
    write_attribute(:slug, value) if value.present?
  end
end
