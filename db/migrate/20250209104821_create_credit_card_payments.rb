class CreateCreditCardPayments < ActiveRecord::Migration[8.0]
  def change
    create_table :credit_card_payments do |t|
      t.references :statement, null: false, foreign_key: { to_table: "credit_card_statements" }
      t.references :account, null: false, foreign_key: true
      t.date :date, null: false
      t.decimal :value, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
