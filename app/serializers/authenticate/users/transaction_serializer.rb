module Authenticate
  module Users
    class TransactionSerializer < TransactionBaseSerializer
      def amount
        object.amount.format(symbol: nil)
      end
    end
  end
end
