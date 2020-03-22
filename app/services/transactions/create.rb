module Transactions
  class Create < Base
    attr_reader :transaction

    def initialize(user_id:, parameters:)
      @user_id = user_id
      @parameters = parameters || {}
      @errors = []
    end

    def call
      @transaction = Transaction.new(@parameters.merge(budget: budget))
      check(@transaction)
      return self unless valid?

      calculate_budget_amount
      check(budget)
      return self unless valid?

      @transaction.save
      budget.save
      self
    end

    private

    def budget
      @budget ||= Budget.find_or_initialize_by(user_id: @user_id) do |budget|
        budget.uuid = SecureRandom.uuid
      end
    end

    def calculate_budget_amount
      budget.amount = budget.amount.public_send(@transaction.operator, @transaction.amount)
    end
  end
end
