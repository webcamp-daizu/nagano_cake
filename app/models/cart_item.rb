class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  def subtotal
    (self.item.add_tax_included_price * self.quantity).round
  end
end
