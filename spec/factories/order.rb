FactoryBot.define do
  factory :order do
    name { "宛名" }
    address { "住所" }
    post_code { 1234567 }
    total_price { 1000 }
    payment_method { "credit_card" }
    customer
  end
end