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
  has_and_belongs_to_many :buildings, join_table: :postcard_buildings
  has_and_belongs_to_many :subjects, join_table: :postcard_subjects

  has_one_attached :front
  has_one_attached :back
end
