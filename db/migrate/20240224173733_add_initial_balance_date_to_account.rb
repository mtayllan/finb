class AddInitialBalanceDateToAccount < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :initial_balance_date, :date

    reversible do |direction|
      direction.up { execute("UPDATE accounts SET initial_balance_date = created_at") }
      direction.down {}
    end

    change_column_null :accounts, :initial_balance_date, false
  end
end
