class CreditCard < ApplicationRecord
  belongs_to :account

  validates :expiration_day, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 31 }

  def expiration_day_in_month(month)
    last_day_of_month = month.end_of_month.day
    if expiration_day > last_day_of_month
      return last_day_of_month
    end

    expiration_day
  end
end
