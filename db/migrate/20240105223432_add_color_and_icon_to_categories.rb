class AddColorAndIconToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :color, :string, null: false, default: "#000000"
    add_column :categories, :icon, :string, null: false, default: ""
  end
end
