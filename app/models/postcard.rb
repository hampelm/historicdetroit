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
  has_and_belongs_to_many :buildings, join_table: :buildings_postcards
  has_and_belongs_to_many :subjects, join_table: :postcards_subjects

  has_one_attached :front
  has_one_attached :back

  def polaroid
    front.andand.variant(combine_options: {thumbnail: '218x200^', gravity: 'center', extent: '218x200'}) if front.attachment
  end

  def full(photo)
    photo.andand.variant(combine_options: {gravity: 'center', extent: '1200x'}) if photo.attachment
  end

  def mobile(photo)
    # http://www.imagemagick.org/script/command-line-processing.php#geometry
    photo.andand.variant(combine_options: {gravity: 'center', extent: '600x'}) if photo.attachment
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
