class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy

  def update_balance
    update(balance: initial_balance + transactions.sum(:value))
  end
end
