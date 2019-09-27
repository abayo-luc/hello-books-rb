FactoryBot.define do
  factory :category do
    name { Faker::String.unique.random(length: 3..4) }
    created_at { Faker::Date.backward(days: 5) }
    updated_at { Faker::Date.backward(days: 1) }
  end
end
