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
  has_one_attached :photo

end
