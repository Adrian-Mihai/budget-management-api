module Authenticate
  class TransactionSerializer < ActiveModel::Serializer
    attributes :uuid, :operator, :amount, :description, :date

    def amount
      object.amount.format
    end

    def date
      object.creation_date.strftime('%d-%m-%Y %T')
    end
  end
end
