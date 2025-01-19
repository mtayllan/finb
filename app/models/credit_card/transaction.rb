class CreditCard::Transaction < ApplicationRecord
  belongs_to :statement
  belongs_to :category

  validates :value, :total_installments, :description, :date, presence: true
end
