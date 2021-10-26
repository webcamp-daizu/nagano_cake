# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

  # 管理者
  Admin.create!(
  email: 'admin@admin',
  password: 'adminadmin'
  )

  # 会員
  15.times do |n|
      Customer.create!(
        email: "hanako#{n + 1}@test.com",
        password: "111111",
        last_name: "山田",
        first_name: "花子#{n + 1}",
        last_name_kana: "ヤマダ",
        first_name_kana: "ハナコ",
        address: "東京都渋谷区ちぇるちぇるランド",
        post_code: "0000000",
        phone_number: "09012345678",
      )
  end

  # 配送先
  ShippingAddress.create!(
    customer_id: 1,
    name: "山田一郎",
    address: "東京都渋谷区こりん星",
    post_code: "1111111",
  )

  # ShippingAddress.create!(
  #   customer_id: 1,
  #   name: "山田二郎",
  #   address: "東京都渋谷区神南1丁目19-11 パークウェースクエア2 4階",
  #   post_code: "2222222",
  # )

  # ジャンル
  Genre.create!(
    name: "ケーキ"
  )
  Genre.create!(
    name: "キャンディ"
  )
  Genre.create!(
    name: "焼き菓子"
  )
  Genre.create!(
    name: "プリン"
  )

  # 商品
  Item.create!(
    genre_id: 1,
    name: "カップケーキ",
    description: "3個入り",
    image: File.open("#{Rails.root}/app/assets/images/cake1.jpeg"),
    is_active: true,
    tax_encluded_price: 1000
  )
  Item.create!(
    genre_id: 1,
    name: "ショートケーキ",
    description: "おいしいいいいい！",
    image: File.open("#{Rails.root}/app/assets/images/cake2.jpeg"),
    is_active: true,
    tax_encluded_price: 500
  )
  Item.create!(
    genre_id: 1,
    name: "ミルフィーユ",
    description: "いちごいっぱいだよ",
    image: File.open("#{Rails.root}/app/assets/images/cake3.jpeg"),
    is_active: true,
    tax_encluded_price: 600
  )
  Item.create!(
    genre_id: 2,
    name: "キャンディー",
    description: "飴ちゃん",
    image: File.open("#{Rails.root}/app/assets/images/candy.jpg"),
    is_active: true,
    tax_encluded_price: 300
  )
  Item.create!(
    genre_id: 3,
    name: "クッキー",
    description: "カオこわい",
    image: File.open("#{Rails.root}/app/assets/images/cookie.jpg"),
    is_active: true,
    tax_encluded_price: 700
  )
  Item.create!(
    genre_id: 4,
    name: "プリンアラモード",
    description: "プッチンプリン",
    image: File.open("#{Rails.root}/app/assets/images/pudding.jpg"),
    is_active: true,
    tax_encluded_price: 500
  )

  15.times do |n|
    # カート商品
    CartItem.create!(
      customer_id: 15 - n,
      item_id: 1,
      quantity: 2
    )

    # 注文
    Order.create!(
      customer_id: 15 - n,
      name: "山田花子",
      address: "東京都渋谷区ちぇるちぇるランド",
      post_code: "0000000",
      total_price: "10800",
      payment_method: 0,
      order_status: 4,
      created_at: (15 - n).day.ago
    )
  end