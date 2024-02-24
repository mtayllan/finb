class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :balances, dependent: :destroy

  validates :name, :color, :initial_balance, :kind, :initial_balance_date, presence: true

  enum :kind, [:checking, :savings, :credit_card, :investment]

  def update_balance
    update(balance: initial_balance + transactions.sum(:value) - transfers_as_origin.sum(:value) + transfers_as_target.sum(:value))
    Account::UpdateBalances.call(self)
  end

  def transfers_as_origin
    Transfer.where(origin_account: self)
  end

  def transfers_as_target
    Transfer.where(target_account: self)
  end
end
