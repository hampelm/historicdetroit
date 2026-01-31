# == Schema Information
#
# Table name: galleries
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#  building_id :integer
#  published   :boolean
#

FactoryBot.define do
  factory :gallery do
    title { Faker::Lorem.sentence(word_count: 4) }
    description { Faker::Lorem.paragraph }
    published { true }
  end
end
