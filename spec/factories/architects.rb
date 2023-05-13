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
#  photo                 :string
#

FactoryBot.define do
  first = Faker::Name.first_name
  last = Faker::Name.last_name

  factory :architect do
    name { first + ' '  + last }
    byline { Faker::Name.name }
    last_name_first { last + ', ' + first }
    firm { Faker::Company.name }
    description { Faker::Markdown.sandwich(sentences: 5) }
    birth { Faker::Date.birthday(45, 65) }
    death { Faker::Date.birthday(18, 44) }
  end
end
