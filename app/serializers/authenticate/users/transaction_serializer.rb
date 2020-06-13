module Authenticate
  module Users
    class TransactionSerializer < ActiveModel::Serializer
      attributes :uuid, :operator, :amount, :description, :date

      def amount
        object.amount.format(symbol: nil, thousands_separator: ',', decimal_mark: '.')
      end

      def date
        object.updated_at.strftime('%d-%m-%Y %T')
      end
    end
  end
end
