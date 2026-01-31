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
#  date           :datetime
#  photo          :string
#

FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence(word_count: 5) }
    body { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    date { Faker::Date.between(from: 30.days.ago, to: Date.today) }
  end
end
