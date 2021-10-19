# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


  15.times do |n|
    Customer.create!(
      email: "test#{n + 1}@test.com",
      password: "111111",
      last_name: "test",
      first_name: "#{n + 1}",
      last_name_kana: "テスト",
      first_name_kana: "#{n + 1}",
      address: "a県",
      post_code: "0000000",
      phone_number: "11111111",
    )
  end

  Admin.create!(
  email: 'test@test',
  password: 'testtest'
  )