module Budgets
  class Create < Base
    def initialize(parameters:)
      @parameters = parameters
      @errors = []
    end

    def call
      @budget = Budget.new(@parameters)
      add_uuid_to_transactions
      check(@budget)
      return self unless valid?

      calculate_budget_amount
      check(@budget)
      return self unless valid?

      @budget.save
      self
    end

    private

    def add_uuid_to_transactions
      @budget.transactions.each { |transaction| transaction.uuid = SecureRandom.uuid }
    end

    def calculate_budget_amount
      @budget.transactions.each do |transaction|
        @budget.amount = @budget.amount.public_send(transaction.operator, transaction.amount)
      end
    end
  end
end
