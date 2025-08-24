class AddFromSplitFlagToTransaction < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :from_split, :boolean, default: false
    change_column_null :transactions, :account_id, true
  end
end
