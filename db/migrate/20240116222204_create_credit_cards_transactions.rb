class CreateCreditCardsTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :credit_card_transactions do |t|
      t.references :bill, null: false, foreign_key: { to_table: :credit_card_bills }
      t.decimal :value, precision: 10, scale: 2, null: false
      t.references :category, null: false, foreign_key: { to_table: :categories }
      t.date :date, null: false
      t.string :description

      t.timestamps
    end
  end
end
