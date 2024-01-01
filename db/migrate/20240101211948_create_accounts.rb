class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.decimal :initial_balance, precision: 9, scale: 2, default: 0, null: false
      t.decimal :balance, precision: 9, scale: 2, default: 0, null: false

      t.timestamps
    end
  end
end
