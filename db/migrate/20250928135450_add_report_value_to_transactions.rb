class AddReportValueToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :report_value, :decimal, precision: 9, scale: 2
  end
end
