# == Schema Information
#
# Table name: postcards
#
#  id          :integer          not null, primary key
#  title       :string
#  caption     :text
#  byline      :string
#  subject     :string
#  building_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#

class Postcard < ApplicationRecord
  include ImageHelper

  has_and_belongs_to_many :buildings, join_table: :buildings_postcards
  has_and_belongs_to_many :subjects, join_table: :postcards_subjects

  has_one_attached :front
  has_one_attached :back

  def photo
    return front if front
    back
  end

  def front_full
    full(front)
  end

  def front_mobile
    mobile(front)
  end

  def back_full
    full(back)
  end

  def back_mobile
    mobile(front)
  end
end
