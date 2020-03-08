class Transaction < ApplicationRecord
  monetize :amount_cents, numericality: { greater_than_or_equal_to: 0 }

  ALLOWED_OPERATORS = %w[+ -].freeze

  validate :allowed_operators

  validates :pay_day, presence: true

  belongs_to :user
  belongs_to :budget

  private

  def allowed_operators
    return if ALLOWED_OPERATORS.include?(operator)

    errors.add(:operator, 'value is invalid')
  end
end
