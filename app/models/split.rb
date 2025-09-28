class Split < ApplicationRecord
  belongs_to :payer_transaction, class_name: "Transaction"
  belongs_to :borrower, class_name: "User"
  belongs_to :borrower_transaction, class_name: "Transaction", optional: true

  validates :amount_borrowed, presence: true, numericality: {greater_than: 0}
  validates :payer_transaction_id, uniqueness: {message: "can only have one split per transaction"}
  validates :borrower_transaction_id, uniqueness: {message: "can only have one split per transaction"}, allow_nil: true

  after_destroy :update_payer_transaction_report_value
  after_save :update_payer_transaction_report_value

  def transaction_value
    payer_transaction.value.abs
  end

  private

  def update_payer_transaction_report_value
    payer_transaction.reload
    payer_transaction.report_value = payer_transaction.calculate_report_value
    payer_transaction.save!
  end
end
