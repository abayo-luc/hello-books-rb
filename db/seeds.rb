# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
10.times do
  User.create(
    email: Faker::Internet.unique.email,
    password: 'password',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    address: Faker::Address.street_address,
    bio: Faker::String.random(length: [0, 250]),
    phone_number: Faker::PhoneNumber.unique.cell_phone,
    confirmed_at: Faker::Date.between(from: 7.days.ago, to: Date.today)
  )
end

100.times do
  Book.create(
    title: Faker::Book.unique.title,
    language: Faker::Nation.language,
    page_number: Faker::Number.between(from: 150, to: 1000),
    isbn: "#{Faker::Number.unique.number(digits: 10)}"
  )
end

50.times do
  Category.create(
    name: Faker::Book.genre
  )
end
