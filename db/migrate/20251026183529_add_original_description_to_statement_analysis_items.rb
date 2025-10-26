class AddOriginalDescriptionToStatementAnalysisItems < ActiveRecord::Migration[8.0]
  def change
    add_column :statement_analysis_items, :original_description, :string
  end
end
