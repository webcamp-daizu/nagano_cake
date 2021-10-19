class Order < ApplicationRecord
  enum payment_method: { credit_card: 0, transfer: 1 }

  def set_receiver(receiver)
    self.address = receiver.address
    self.post_code = receiver.post_code
    if receiver.is_a?(Customer)
      self.name = receiver.nameaaaaaaaaa
    else
      self.name = receiver.name
    end
  end
end
