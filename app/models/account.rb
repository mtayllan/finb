class Account < ApplicationRecord
  belongs_to :user

  has_many :transactions, dependent: :destroy
  has_many :balances, dependent: :destroy
  has_many :transfers_as_origin, class_name: "Transfer", foreign_key: "origin_account_id", dependent: :destroy
  has_many :transfers_as_target, class_name: "Transfer", foreign_key: "target_account_id", dependent: :destroy

  validates :name, :color, :initial_balance, :kind, :initial_balance_date, presence: true

  enum :kind, [:checking, :savings, :credit_card, :investment]

  def update_balance
    update(balance: initial_balance + transactions.sum(:value) - transfers_as_origin.sum(:value) + transfers_as_target.sum(:value))
    Account::UpdateBalances.call(self)
  end

  def self.update_balance(account_id)
    find(account_id).update_balance
  end
end
