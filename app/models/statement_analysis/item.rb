class StatementAnalysis::Item < ApplicationRecord
  self.table_name = "statement_analysis_items"

  belongs_to :statement_analysis
  belongs_to :category, optional: true

  validates :description, :date, :value, :row_number, presence: true
  validate :date_after_account_initial_balance_date

  def calculated_value
    return value unless statement_analysis.account.credit_card?

    value * -1
  end

  private

  def date_after_account_initial_balance_date
    return if date.nil?

    account = statement_analysis.account
    return if account.nil?

    if date < account.initial_balance_date
      errors.add(:date, "must be after account's initial balance date: #{account.initial_balance_date}")
    end
  end
end
