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

  ShippingAddress.create!(
    customer_id: 1,
    name: "山田花子",
    address: "東京都渋谷区神南1丁目19-11 パークウェースクエア2 4階",
    post_code: "1500041",
  )

  Genre.create!(
    name: "ケーキ"
  )

  Item.create!(
    genre_id: 1,
    name: "いちごのショートケーキ",
    description: "栃木県産のとちおとめを贅沢に使用しています。",
    image_id: "hoge",
    is_active: true,
    tax_encluded_price: 800
  )

  # 15.times do |n|
  #   CartItem.create!(
  #     customer_id: 1,
  #     item_id: 1,
  #     quantity: n + 1
  #   )

  #   Order.create!(
  #     customer_id: 1,
  #     name: "山田花子",
  #     address: "東京都渋谷区神南1丁目19-11 パークウェースクエア2 4階",
  #     post_code: "1500041",
  #     total_price: "10000",
  #     payment_method: 0
  #   )
  # end

  # CartItem.create!(
  #   customer_id: 1,
  #   item_id: 1,
  #   quantity: 2
  # )

  Admin.create!(
  email: 'admin@admin',
  password: 'adminadmin'
  )
