class CreateCreditCardStatements < ActiveRecord::Migration[8.0]
  def change
    create_table :credit_card_statements do |t|
      t.references :credit_card, null: false, foreign_key: true
      t.date :closing_date, null: false
      t.date :due_date, null: false
      t.date :paid_at, null: true

      t.timestamps
    end
  end
end
