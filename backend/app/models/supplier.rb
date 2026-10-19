class Supplier < ApplicationRecord
  validates :name, presence: true
  validates :status, inclusion: { in: %w[active inactive] }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end
