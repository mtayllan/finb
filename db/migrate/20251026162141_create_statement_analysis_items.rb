class CreateStatementAnalysisItems < ActiveRecord::Migration[8.0]
  def change
    create_table :statement_analysis_items do |t|
      t.references :statement_analysis, null: false, foreign_key: true, index: true
      t.string :description, null: false
      t.date :date, null: false
      t.decimal :value, precision: 9, scale: 2, null: false
      t.references :category, null: true, foreign_key: true
      t.boolean :should_import, default: true, null: false
      t.integer :row_number, null: false

      t.timestamps
    end
  end
end
