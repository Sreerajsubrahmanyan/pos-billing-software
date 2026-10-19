class Sale < ApplicationRecord
  belongs_to :user
  has_many :sale_items, dependent: :destroy

  validates :bill_number, presence: true, uniqueness: true
  validates :payment_method, presence: true
  validates :status, presence: true
  validates :subtotal, :tax_amount, :discount_amount, :total_amount,
            numericality: { greater_than_or_equal_to: 0 }
end