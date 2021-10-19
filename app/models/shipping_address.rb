class ShippingAddress < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :address, presence: true
  validates :post_code, presence: true

end
