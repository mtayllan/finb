class CreateSplits < ActiveRecord::Migration[8.0]
  def change
    create_table :splits do |t|
      t.references :source_transaction, null: false, foreign_key: {to_table: :transactions}, index: {unique: true}
      t.references :payer, null: false, foreign_key: {to_table: :users}
      t.references :owes_to, null: false, foreign_key: {to_table: :users}
      t.decimal :amount_owed, precision: 9, scale: 2, null: false
      t.references :owes_to_category, null: true, foreign_key: {to_table: :categories}
      t.datetime :paid_at

      t.timestamps
    end

    add_index :splits, [:payer_id, :owes_to_id]
    add_index :splits, :paid_at
  end
end
