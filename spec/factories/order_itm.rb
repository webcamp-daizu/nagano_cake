FactoryBot.define do
  factory :order_item do
    tax_included_price { 1000 }
    quantity { 5 }
    order
    item
  end
end