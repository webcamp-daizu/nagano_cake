FactoryBot.define do
  factory :item do
    genre_id { 1 }
    name { Faker::Lorem.characters(number: 5) }
    description { Faker::Lorem.characters(number: 20) }
    image { File.open("#{Rails.root}/app/assets/images/test.jpg") }
    is_active { true }
    tax_encluded_price { 1000 }
  end
end
