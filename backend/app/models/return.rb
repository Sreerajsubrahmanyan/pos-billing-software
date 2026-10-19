class Return < ApplicationRecord
  belongs_to :sale
  belongs_to :product
  belongs_to :user

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :refund_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :reason, presence: true
end
