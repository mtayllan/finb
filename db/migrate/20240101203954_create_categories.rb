class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.references :parent_category, null: true, foreign_key: {to_table: :categories}

      t.timestamps
    end
  end
end
