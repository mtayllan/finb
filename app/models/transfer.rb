class Transfer < ApplicationRecord
  belongs_to :origin_account, class_name: 'Account'
  belongs_to :target_account, class_name: 'Account'

  validates :date, :value, presence: true
  validate :different_accounts

  private

  def different_accounts
    errors.add(:target_account, "must be different from Origin Account") if origin_account_id == target_account_id
  end
end
