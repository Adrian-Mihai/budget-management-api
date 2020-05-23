class RemoveCreationDate < ActiveRecord::Migration[6.0]
  def change
    remove_column :transactions, :creation_date
  end
end
