class AddExcludeFromReportsToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :exclude_from_reports, :boolean, default: false, null: false
  end
end
