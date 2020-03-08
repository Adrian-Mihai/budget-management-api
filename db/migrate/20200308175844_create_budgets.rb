class CreateBudgets < ActiveRecord::Migration[6.0]
  def change
    create_table :budgets do |t|
      t.belongs_to :user
      t.monetize :amount

      t.timestamps
    end
  end
end
