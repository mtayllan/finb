class CreateCreditCardStatements < ActiveRecord::Migration[8.0]
  def change
    create_table :credit_card_statements do |t|
      t.references :credit_card, null: false, foreign_key: true
      t.datetime :paid_at
      t.datetime :due_date, null: false

      t.timestamps
    end
  end
end
