class Order < ApplicationRecord
  after_create :move_cart_items
  after_update :check_order_status

  enum payment_method: {
    credit_card: 0,
    transfer: 1
  }
  enum order_status: {
    wating_for_payment: 0,
    confirmed_payment: 1,
    making: 2,
    preparing_to_ship: 3,
    shipped: 4
  }

  belongs_to :customer
  has_many :order_items, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true
  validates :post_code, presence: true
  validates :shipping_fee, presence: true
  validates :total_price, presence: true
  validates :payment_method, presence: true
  validates :order_status, presence: true

  def set_receiver(receiver)
    self.address = receiver.address
    self.post_code = receiver.post_code
    if receiver.is_a?(Customer)
      self.name = receiver.full_name.gsub(" ", "")
    else
      self.name = receiver.name
    end
  end

  def order_items_total_price
    (self.total_price - self.shipping_fee).round
  end

  def order_items_total_quantity
    self.order_items.sum(:quantity)
  end

  private

  def move_cart_items
    cart_items_list = self.customer.cart_items.map do |cart_item|
      {
        item_id: cart_item.item_id,
        tax_included_price: cart_item.item.add_tax_included_price,
        quantity: cart_item.quantity
      }
    end
    self.order_items.create(cart_items_list)
    self.customer.cart_items.destroy_all
  end

  def check_order_status
    if self.order_status == "confirmed_payment"
      self.order_items.update_all(make_status: "wating_for_make")
    end
  end
end
