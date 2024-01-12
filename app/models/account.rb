class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy

  validates :name, :color, :initial_balance, presence: true

  def update_balance
    update(balance: initial_balance + transactions.sum(:value) - transfers_as_origin.sum(:value) + transfers_as_target.sum(:value))
  end

  def transfers_as_origin
    Transfer.where(origin_account: self)
  end

  def transfers_as_target
    Transfer.where(target_account: self)
  end
end
