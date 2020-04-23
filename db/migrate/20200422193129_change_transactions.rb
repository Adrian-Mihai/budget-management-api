class ChangeTransactions < ActiveRecord::Migration[6.0]
  def change
    add_reference(:transactions, :user, foreign_key: true)
    remove_timestamps(:transactions)
    add_column(:transactions, :creation_date, :datetime, null: false, limit: 6)
    add_timestamps(:transactions)
  end
end
