class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.belongs_to :budget, foreign_key: true
      t.string :uuid, null: false, index: { unique: true }
      t.string :operator, null: false
      t.monetize :amount
      t.date :pay_day, null: false
      t.text :description, null: false, default: ''

      t.timestamps
    end
  end
end
