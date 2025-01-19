class CreditCard::TransactionInstallment < ApplicationRecord
  belongs_to :original_transaction, class_name: "CreditCard::Transaction"
  belongs_to :statement

  validates :value, :number, presence: true
end
