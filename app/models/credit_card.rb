class CreditCard < ApplicationRecord
  validates :due_day, :close_day, :color, presence: true

  validates :due_day, :close_day, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }

  def create_bills
    -3.upto(13) do |i|
      month = i.months.from_now.beginning_of_month
      next if Bill.exists?(credit_card: self, period: month)
      Bill.create(credit_card: self, period: month, value: 0)
    end
  end
end
