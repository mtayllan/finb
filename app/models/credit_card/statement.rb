class CreditCard::Statement < ApplicationRecord
  belongs_to :account
  has_many :transactions, dependent: :nullify, inverse_of: :credit_card_statement

  def update_value
    return if destroyed?

    update(value: transactions.sum(:value) * -1)
  end

  def self.update_value(statement_id)
    find(statement_id).update_value
  end
end
