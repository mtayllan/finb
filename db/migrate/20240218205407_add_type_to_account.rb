class AddTypeToAccount < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :type, :integer, null: false, default: 0
  end
end
