FactoryBot.define do
  factory :shipping_address do
    name { "宛名" }
    address { "住所" }
    post_code { 1234567 }
    customer
  end
end