class AddUniqueConstraintToSplits < ActiveRecord::Migration[8.0]
  def change
    remove_index :splits, :payer_transaction_id
    add_index :splits, :payer_transaction_id, unique: true

    remove_index :splits, :borrower_transaction_id
    add_index :splits, :borrower_transaction_id, unique: true, where: "borrower_transaction_id IS NOT NULL"
  end
end
