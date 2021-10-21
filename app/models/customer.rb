class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cart_items, dependent: :destroy
  has_many :shipping_addresses, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name_kana, format: { with: /\A[ァ-ヶー－]+\z/, message: "は全角カタカナで入力してください" }
  validates :first_name_kana, format: { with: /\A[ァ-ヶー－]+\z/, message: "は全角カタカナで入力してください" }
  validates :post_code, format: { with: /\A\d{7}\z/, message: "は7桁で入力してください" }
  validates :address, presence: true
  validates :phone_number, format: { with: /\A\d{10,11}\z/, message: "は10桁または11桁で入力してください" }

  def full_name
    self.last_name + " " + self.first_name
  end

  def full_name_kana
    self.last_name_kana + " " + self.first_name_kana
  end

  def full_name_no_blanks
    self.last_name + self.first_name
  end

  def address_in_one_line
    "〒" + self.post_code + " " + self.address + " " + self.last_name + self.first_name
  end

  def cart_items_total_price
    sum = 0
    self.cart_items.each { |cart_item| sum += cart_item.sum_of_price }
    return sum
  end

end
