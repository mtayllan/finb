class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :description
      t.decimal :value, precision: 9, scale: 2, default: 0, null: false
      t.references :category, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.date :date, null: false

      t.timestamps
    end
  end
end
