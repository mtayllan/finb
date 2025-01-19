class CreditCard::Statement < ApplicationRecord
  belongs_to :credit_card

  validates :due_date, presence: true
end
