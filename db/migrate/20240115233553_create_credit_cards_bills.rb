class CreateCreditCardsBills < ActiveRecord::Migration[7.1]
  def change
    create_table :credit_card_bills do |t|
      t.date :period, null: false
      t.references :credit_card, null: false, foreign_key: { on_delete: :cascade }
      t.decimal :value, null: false, precision: 10, scale: 2, default: 0
      t.references :payment_account, null: true, foreign_key: { to_table: :accounts, on_delete: :nullify }

      t.timestamps
    end
  end
end
