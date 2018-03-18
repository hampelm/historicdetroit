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
#

class Architect < ApplicationRecord
end
