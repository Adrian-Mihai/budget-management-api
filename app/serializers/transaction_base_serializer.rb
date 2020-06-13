class TransactionBaseSerializer < ActiveModel::Serializer
  attributes :uuid, :operator, :amount, :description, :date

  def amount
    object.amount.format
  end

  def date
    object.updated_at.strftime('%d-%m-%Y %T')
  end
end
