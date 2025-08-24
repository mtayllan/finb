class Split < ApplicationRecord
  belongs_to :payer_transaction, class_name: "Transaction"
  belongs_to :borrower, class_name: "User"
  belongs_to :borrower_transaction, class_name: "Transaction", optional: true

  validates :amount_borrowed, presence: true, numericality: {greater_than: 0}
  validates :payer_transaction_id, uniqueness: {message: "can only have one split per transaction"}
  validates :borrower_transaction_id, uniqueness: {message: "can only have one split per transaction"}, allow_nil: true

  def transaction_value
    payer_transaction.value.abs
  end
end
