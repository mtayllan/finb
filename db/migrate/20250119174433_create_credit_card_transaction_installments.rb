class CreateCreditCardTransactionInstallments < ActiveRecord::Migration[8.0]
  def change
    create_table :credit_card_transaction_installments do |t|
      t.references :original_transaction, null: false, foreign_key: { to_table: :credit_card_transactions }
      t.references :statement, null: false, foreign_key: { to_table: :credit_card_statements }
      t.decimal :value, null: false
      t.integer :number, null: false

      t.timestamps
    end
  end
end
