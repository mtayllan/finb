class PopulateReportValueForExistingTransactions < ActiveRecord::Migration[8.0]
  def up
    Transaction.find_each do |transaction|
      transaction.update_column(:report_value, transaction.calculated_report_value)
    end
  end

  def down
    Transaction.update_all(report_value: nil)
  end
end
