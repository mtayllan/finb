class CreditCards::Transaction < ApplicationRecord
  belongs_to :bill, class_name: 'CreditCard::Bill'
  belongs_to :category

  validates :value, :date, :description, presence: true
  validates :value, numericality: { other_than: 0 }
end
