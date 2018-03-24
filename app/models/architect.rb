# == Schema Information
#
# Table name: architects
#
#  id              :integer          not null, primary key
#  name            :string
#  byline          :string
#  last_name_first :string
#  firm            :string
#  description     :text
#  birth           :string
#  death           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  building_id     :integer
#

class Architect < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_one_attached :photo
  has_and_belongs_to_many :buildings, :join_table => :building_architects
end
