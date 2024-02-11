class AddColorToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :color, :string, null: false, default: "#000000"
  end
end
