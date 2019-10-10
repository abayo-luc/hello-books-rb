FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    confirmed_at { Faker::Date.backward(days: 5) }
    created_at { Faker::Date.backward(days: 5) }
    updated_at { Faker::Date.backward(days: 1) }
  end
end
