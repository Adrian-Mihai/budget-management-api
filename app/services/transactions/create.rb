module Transactions
  class Create < Base
    attr_reader :transaction

    def initialize(parameters:)
      @parameters = parameters || {}
      @errors = []
    end

    def call
      @transaction = Transaction.new(@parameters)
      check(@transaction)
      return self unless valid?

      @transaction.save
      self
    end
  end
end
