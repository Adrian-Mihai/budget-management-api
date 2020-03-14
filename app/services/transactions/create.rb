module Transactions
  class Create < Base
    def initialize(parameters:)
      @parameters = parameters
      @errors = []
    end

    def call
      @transaction = Transaction.new(@parameters)
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
      @budget ||= @transaction.budget
    end

    def calculate_budget_amount
      budget.amount = budget.amount.public_send(@transaction.operator, @transaction.amount)
    end
  end
end
