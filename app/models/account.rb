class Account < ApplicationRecord
  belongs_to :user

  has_many :transactions, dependent: :destroy
  has_many :balances, dependent: :destroy
  has_many :transfers_as_origin, class_name: "Transfer", foreign_key: "origin_account_id", dependent: :destroy
  has_many :transfers_as_target, class_name: "Transfer", foreign_key: "target_account_id", dependent: :destroy
  has_many :statement_analyses, dependent: :destroy

  validates :name, :color, :initial_balance, :kind, :initial_balance_date, presence: true

  enum :kind, {checking: 0, savings: 1, credit_card: 2, investment: 3}

  has_many :credit_card_statements, class_name: "CreditCard::Statement", dependent: :destroy

  def update_balance(start_date: nil)
    return if destroyed?

    transactions_value = transactions.where(date: ..Date.current).sum(:value)
    transfers_as_origin_value = transfers_as_origin.where(date: ..Date.current).sum(:value)
    transfers_as_target_value = transfers_as_target.where(date: ..Date.current).sum(:value)

    update(balance: initial_balance + transactions_value + transfers_as_target_value - transfers_as_origin_value)
    Account::UpdateBalances.call(self, start_date: start_date)
  end

  def self.update_balance(account_id, start_date: nil)
    find(account_id).update_balance(start_date: start_date)
  end
end
