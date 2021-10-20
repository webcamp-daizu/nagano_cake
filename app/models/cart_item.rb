class CartItem < ApplicationRecord
  belongs_to :item
  belongs_to :customer
  
  validates :quantity, presence: true
  
  # カート内の商品合計に利用
  def sum_of_price
    item.add_tax_included_price * quantity
  end

end
