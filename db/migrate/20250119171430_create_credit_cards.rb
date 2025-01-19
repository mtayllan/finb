class CreateCreditCards < ActiveRecord::Migration[8.0]
  def change
    create_table :credit_cards do |t|
      t.references :account, null: false, foreign_key: true
      t.integer :expiration_day, null: false, default: 1

      t.timestamps
    end
  end
end
