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
end
