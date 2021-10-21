class Item < ApplicationRecord
  belongs_to :genre
  attachment :image

  validates :name, presence: true
  validates :image, presence: true
  validates :description, presence: true
  validates :tax_encluded_price, presence: true
  validates :is_active, inclusion: [true, false]

  def add_tax_included_price
    (self.tax_encluded_price * 1.08).round
  end

  def self.search(search)
    if search != ""
      Item.where('name LIKE ?', "%#{search}%")
    else
      Item.all
    end
  end
end
