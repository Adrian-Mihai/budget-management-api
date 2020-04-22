module Graphs
  class Show
    attr_reader :informations

    def initialize(user:)
      @user = user
      @budget_history = Money.new(0)
      @informations = {}
    end

    def call
      @user.budget.transactions.order(:created_at).each do |transaction|
        @budget_history = @budget_history.public_send(transaction.operator, transaction.amount) 
        informations[transaction.created_at.strftime('%d-%m-%y')] = @budget_history.format
      end
      self
    end
  end
end
