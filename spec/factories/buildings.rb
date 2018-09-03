# == Schema Information
#
# Table name: buildings
#
#  id                    :integer          not null, primary key
#  name                  :string
#  also_known_as         :string
#  byline                :string
#  description           :text
#  address               :string
#  status                :string
#  style                 :string
#  year_opened           :string
#  year_closed           :string
#  year_demolished       :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  architect_id          :integer
#  description_formatted :text
#  slug                  :string
#  lat                   :decimal(, )
#  lng                   :decimal(, )
#

FactoryBot.define do
  factory :building do
    name { Faker::Company.name }
    also_known_as { Faker::Company.name }
    byline { FFaker::Name.name }
    description { Faker::Markdown.sandwich(5) }
    address { Faker::Address.address }
    status { 'Demolished' }
    style { 'Art Deco' }
    year_opened { Faker::Date.birthday(45, 65) }
    year_closed { Faker::Date.birthday(18, 44) }
    year_demolished { Faker::Date.birthday(18, 44) }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
  end
end