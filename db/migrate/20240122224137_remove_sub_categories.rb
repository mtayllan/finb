class RemoveSubCategories < ActiveRecord::Migration[7.1]
  def change
    remove_reference :categories, :parent_category, foreign_key: { to_table: :categories }
  end
end
