class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true

  has_many :accounts, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :credit_card_statements, through: :accounts
  has_many :tags, dependent: :destroy
  has_many :chat_messages, dependent: :destroy

  def transactions
    Transaction.left_joins(:borrower_split).where(account: accounts).or(
      Transaction.left_joins(:borrower_split).where(splits: {borrower_id: id})
    )
  end

  def transfers
    transfers = Transfer.joins(:origin_account, :target_account)
    transfers.where({origin_account: {user_id: id}})
      .or(transfers.where({target_account: {user_id: id}}))
  end

  def splits_as_borrower
    Split.where(borrower: self)
  end

  def splits_as_payer
    Split.joins(payer_transaction: :account).where(accounts: {user_id: id})
  end

  def superuser?
    superuser
  end
end
