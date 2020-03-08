class Budget < ApplicationRecord
  monetize :amount_cents, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :user
  has_many :transactions, dependent: :destroy
end
