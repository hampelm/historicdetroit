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
#  slug            :string
#

require 'test_helper'

class ArchitectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
