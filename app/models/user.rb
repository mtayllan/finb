class User < ApplicationRecord
  include Splittable

  has_secure_password

  has_many :accounts, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :credit_card_statements, through: :accounts
  has_many :transactions, through: :accounts

  def transfers
    transfers = Transfer.joins(:origin_account, :target_account)
    transfers.where({origin_account: {user_id: id}})
      .or(transfers.where({target_account: {user_id: id}}))
  end

  def all_splits
    Split.where("payer_id = ? OR owes_to_id = ?", id, id)
  end
end
