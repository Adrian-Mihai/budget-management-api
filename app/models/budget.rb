class Budget < ApplicationRecord
  monetize :amount_cents, numericality: { greater_than_or_equal_to: 0 }

  validates :uuid, presence: true, uniqueness: true
  validates :user_id, uniqueness: true

  belongs_to :user
  has_many :transactions, dependent: :destroy

  accepts_nested_attributes_for :transactions
end
