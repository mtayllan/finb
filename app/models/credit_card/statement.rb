class CreditCard::Statement < ApplicationRecord
  belongs_to :account
  has_many :transactions, dependent: :nullify, inverse_of: :credit_card_statement

  def update_value
    update(value: transactions.sum(:value) * -1)
  end
end
