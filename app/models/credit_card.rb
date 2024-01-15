class CreditCard < ApplicationRecord
  validates :due_day, :close_day, :color, presence: true

  validates :due_day, :close_day, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }
end
