class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.belongs_to :user
      t.belongs_to :budget
      t.string :operator, null: false
      t.monetize :amount
      t.text :description, default: ''
      t.date :pay_day, null: false

      t.timestamps
    end
  end
end
