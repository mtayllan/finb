class Transfer < ApplicationRecord
  belongs_to :origin_account, class_name: "Account"
  belongs_to :target_account, class_name: "Account"

  validates :date, :value, presence: true
  validate :different_accounts

  validate :date_after_account_initial_balance_date

  private

  def date_after_account_initial_balance_date
    errors.add(:date, "must be after date of initial balance: #{origin_account.initial_balance_date}") if date < origin_account.initial_balance_date
    errors.add(:date, "must be after date of initial balance: #{target_account.initial_balance_date}") if date < target_account.initial_balance_date
  end

  def different_accounts
    errors.add(:target_account, "must be different from Origin Account") if origin_account_id == target_account_id
  end
end
