class CreateCreditCardTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :credit_card_transactions do |t|
      t.references :statement, null: false, foreign_key: { to_table: :credit_card_statements }
      t.decimal :value, null: false
      t.integer :total_installments, null: false
      t.references :category, null: false, foreign_key: true
      t.string :description, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
