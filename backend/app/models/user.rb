class User < ApplicationRecord
  has_secure_password
  has_many :sales, dependent: :restrict_with_error

  ROLES = %w[admin staff].freeze

  validates :name, presence: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :role, inclusion: { in: ROLES }

  before_validation :normalize_email

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end