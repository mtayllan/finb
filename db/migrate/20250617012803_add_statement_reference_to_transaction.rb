class AddStatementReferenceToTransaction < ActiveRecord::Migration[8.0]
  def change
    add_reference :transactions, :credit_card_statement, null: true, foreign_key: true
  end
end
