class User < ApplicationRecord
  has_secure_password

  has_many :accounts, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :credit_cards, dependent: :destroy

  has_many :transactions, through: :accounts
  has_many :credit_card_statements, through: :credit_cards, source: :statements
  has_many :credit_card_transactions, through: :credit_card_statements, source: :transactions

  def transfers
    transfers = Transfer.joins(:origin_account, :target_account)
    transfers.where({ origin_account: { user_id: id } })
      .or(transfers.where({ target_account: { user_id: id } }))
  end
end
