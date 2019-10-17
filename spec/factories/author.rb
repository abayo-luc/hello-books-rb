FactoryBot.define do
    factory :author do
      name { "Luc-#{Time.now.to_i} #{Faker::Name.unique.name}" }
      bio { Faker::Lorem.paragraph_by_chars(number: 250) }
      country { Faker::Nation.nationality }
      birth_date { Faker::Date.backward(days: 360*30) }
      created_at { Faker::Date.backward(days: 5) }
      updated_at { Faker::Date.backward(days: 1) }
    end
  end
