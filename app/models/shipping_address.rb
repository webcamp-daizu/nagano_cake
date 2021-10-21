class ShippingAddress < ApplicationRecord
  belongs_to :customer

  validates :name, presence: true
  validates :address, presence: true
  validates :post_code, presence: true

  def in_one_line
    "〒" + self.post_code + " " + self.address + " " + self.name
  end
end
