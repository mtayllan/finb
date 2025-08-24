class Split < ApplicationRecord
  belongs_to :payer_transaction, class_name: "Transaction"
  belongs_to :borrower, class_name: "User"
  belongs_to :borrower_transaction, class_name: "Transaction", optional: true

  validates :amount_borrowed, presence: true, numericality: {greater_than: 0}

  def transaction_value
    payer_transaction.value.abs
  end
end
