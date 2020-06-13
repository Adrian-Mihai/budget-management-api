module Authenticate
  class TransactionSerializer < TransactionBaseSerializer
    def amount
      object.amount.format(thousands_separator: '.', decimal_mark: ',')
    end
  end
end
