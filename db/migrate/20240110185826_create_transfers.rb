class CreateTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :transfers do |t|
      t.references :origin_account, null: false, foreign_key: {to_table: :accounts}
      t.references :target_account, null: false, foreign_key: {to_table: :accounts}
      t.string :description
      t.decimal :value, null: false, precision: 10, scale: 2
      t.date :date, null: false

      t.timestamps
    end
  end
end
