FactoryBot.define do
  factory :category do
    name { Faker::Beer.unique.brand }
    created_at { Faker::Date.backward(days: 5) }
    updated_at { Faker::Date.backward(days: 1) }
  end
end
