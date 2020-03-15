class CreateBudgets < ActiveRecord::Migration[6.0]
  def change
    create_table :budgets do |t|
      t.belongs_to :user, foreign_key: true, index: { unique: true }
      t.string :uuid, null: false, index: { unique: true }
      t.monetize :amount

      t.timestamps
    end
  end
end
