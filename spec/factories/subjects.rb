FactoryBot.define do
  factory :subject do
    title { Faker::Company.name }
  end
end
