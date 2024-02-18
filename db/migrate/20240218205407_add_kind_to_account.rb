class AddKindToAccount < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :kind, :integer, null: false, default: 0
  end
end
