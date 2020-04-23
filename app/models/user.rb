class User < ApplicationRecord
  has_secure_password

  validates :uuid, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }

  has_many :transactions, dependent: :destroy

  def username
    name || email.split('@').first
  end
end
