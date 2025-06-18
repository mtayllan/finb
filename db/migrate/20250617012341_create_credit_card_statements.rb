class CreateCreditCardStatements < ActiveRecord::Migration[8.0]
  def change
    create_table :credit_card_statements do |t|
      t.date :paid_at
      t.references :account, null: false, foreign_key: true
      t.date :month, null: false
      t.decimal :value, default: 0

      t.timestamps
    end
  end
end
