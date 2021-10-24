FactoryBot.define do
  factory :cart_item do
    quantity { 5 }
    customer
    item
  end
end