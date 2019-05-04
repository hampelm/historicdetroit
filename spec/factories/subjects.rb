# == Schema Information
#
# Table name: subjects
#
#  id            :integer          not null, primary key
#  title         :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  slug          :string
#  photo         :string
#  use_as_filter :boolean
#

FactoryBot.define do
  factory :subject do
    title { Faker::Company.name }
  end
end
