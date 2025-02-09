class CreateCreditCardTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :credit_card_transactions do |t|
      t.decimal :value, null: false, precision: 10, scale: 2
      t.string :description, null: false
      t.references :statement, null: false, foreign_key: { to_table: :credit_card_statements }
      t.date :date, null: false
      t.references :category, null: false, foreign_key: true
      t.references :parent_transaction, foreign_key: { to_table: :credit_card_transactions }
      t.integer :total_installments, null: false, default: 1

      t.timestamps
    end
  end
end
