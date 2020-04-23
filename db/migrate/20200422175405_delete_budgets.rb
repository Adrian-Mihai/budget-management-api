class DeleteBudgets < ActiveRecord::Migration[6.0]
  def change
    remove_reference(:transactions, :budget, foreign_key: true, index: true)
    drop_table(:budgets)
  end
end
