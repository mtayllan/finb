class AddDatesToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :credit_card_expiration_day, :date
  end
end
