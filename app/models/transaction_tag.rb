class TransactionTag < ApplicationRecord
  # use taggable_transaction to avoid conflict with .transaction methods from ActiveRecord
  belongs_to :taggable_transaction, class_name: "Transaction", foreign_key: "transaction_id"
  belongs_to :tag
end
