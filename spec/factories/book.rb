FactoryBot.define do
  factory :book do
    page_number { 565 }
    title { "#{Faker::Book.unique.title}-#{Time.now.to_i}" }
    language { 'English' }
    isbn { Faker::Number.unique.number(digits: 10) }
    inventory { 1 }
    created_at { Faker::Date.backward(days: 5) }
    updated_at { Faker::Date.backward(days: 1) }
  end
end
