class Account < ApplicationRecord
  def update_balance
    update(balance: initial_balance)
  end
end
