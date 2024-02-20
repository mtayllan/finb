class CreateAccountBalances < ActiveRecord::Migration[7.1]
  def change
    create_table :account_balances do |t|
      t.references :account, null: false, foreign_key: { on_delete: :cascade }
      t.date :date, null: false
      t.decimal :balance, precision: 19, scale: 2, null: false

      t.timestamps
    end

    add_index :account_balances, %i[account_id date], unique: true
  end
end
