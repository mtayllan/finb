class AddDefaultCurrencyToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :default_currency, :string, default: "USD", null: false
  end
end
