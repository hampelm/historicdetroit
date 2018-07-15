# == Schema Information
#
# Table name: posts
#
#  id             :integer          not null, primary key
#  title          :string
#  body           :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  slug           :string
#  body_formatted :text
#

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
