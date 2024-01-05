class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy

  validates :name, :color, :initial_balance, presence: true

  def update_balance
    update(balance: initial_balance + transactions.sum(:value))
  end
end
