class Transaction < ApplicationRecord
  monetize :amount_cents, numericality: { greater_than_or_equal_to: 0 }

  validates :uuid, presence: true, uniqueness: true
  validates :operator, presence: true, inclusion: { in: %w[+ -] }

  belongs_to :budget
end
