class Transaction < ApplicationRecord
  include Transaction::Installmentable

  belongs_to :category
  belongs_to :account

  validates :value, :date, :description, presence: true
  validates :value, numericality: { other_than: 0 }
  validate :date_after_account_initial_balance_date

  private

  def date_after_account_initial_balance_date
    return if account.nil? || date.nil?

    errors.add(:date, "must be after date of initial balance: #{account.initial_balance_date}") if date < account.initial_balance_date
  end
end
