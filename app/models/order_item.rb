class OrderItem < ApplicationRecord
  after_update :check_make_status
  enum make_status: {
    not_startable: 0,
    wating_for_make: 1,
    making: 2,
    completed: 3
  }

  belongs_to :order
  belongs_to :item

  def subtotal
    (self.item.add_tax_included_price * self.quantity).round
  end

  private
  def check_make_status
    if self.make_status == "making"
      self.order.update(order_status: "making")
    elsif self.make_status == "completed"
      if self.order.order_items.all? { |order_item| order_item.make_status == "completed" }
        self.order.update(order_status: "preparing_to_ship")
      end
    end
  end
end
