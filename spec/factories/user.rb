FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    created_at { Faker::Date.backward(days: 5) }
    updated_at { Faker::Date.backward(days: 1) }
  end
end
