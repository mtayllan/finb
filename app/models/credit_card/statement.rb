class CreditCard::Statement < ApplicationRecord
  belongs_to :credit_card
  has_many :transactions, class_name: "CreditCard::Transaction", dependent: :destroy

  validates :closing_date, :due_date, presence: true

  def self.find_by_month(month)
    self.where(due_date: month.beginning_of_month..month.end_of_month).first
  end

  def self.find_or_create_by_month(month, credit_card:)
    if statement = self.find_by_month(month)
      statement
    else
      self.create(
        credit_card: credit_card,
        closing_date: month.change(day: credit_card.closing_day),
        due_date: month.change(day: credit_card.due_day)
      )
    end
  end
end
