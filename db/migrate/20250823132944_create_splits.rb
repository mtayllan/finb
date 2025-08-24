class CreateSplits < ActiveRecord::Migration[8.0]
  def change
    create_table :splits do |t|
      t.references :payer_transaction, null: false, foreign_key: {to_table: :transactions}
      t.references :borrower_transaction, null: true, foreign_key: {to_table: :transactions}
      t.references :borrower, null: false, foreign_key: {to_table: :users}
      t.decimal :amount_borrowed, null: false
      t.date :confirmed_at

      t.timestamps
    end
  end
end
