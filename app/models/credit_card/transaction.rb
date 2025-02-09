class CreditCard::Transaction < ApplicationRecord
  belongs_to :statement
  belongs_to :category
  belongs_to :parent_transaction, class_name: "CreditCard::Transaction", optional: true
  has_one :credit_card, through: :statement

  validates :value, :date, presence: true
end
