# == Schema Information
#
# Table name: architects
#
#  id                    :integer          not null, primary key
#  name                  :string
#  byline                :string
#  last_name_first       :string
#  firm                  :string
#  description           :text
#  birth                 :string
#  death                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  slug                  :string
#  description_formatted :text
#

FactoryBot.define do
  factory :architect do
    first = Faker::Name.first_name
    last = Faker::Name.last_name

    name { first + ' '  + last }
    byline { FFaker::Name.name }
    last_name_first { last + ', ' + first }
    firm { Faker::Company.name }
    description { Faker::Markdown.sandwich(5) }
    birth { Faker::Date.birthday(45, 65) }
    death { Faker::Date.birthday(18, 44) }
  end
end
