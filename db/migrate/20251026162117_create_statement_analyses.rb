class CreateStatementAnalyses < ActiveRecord::Migration[8.0]
  def change
    create_table :statement_analyses do |t|
      t.references :account, null: false, foreign_key: true
      t.integer :status, default: 0, null: false
      t.integer :total_rows, null: false
      t.references :credit_card_statement, null: true, foreign_key: true

      t.timestamps
    end
  end
end
