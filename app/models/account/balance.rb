class Account::Balance < ApplicationRecord
  belongs_to :account, optional: false

  validates :date, uniqueness: {scope: :account_id}
end
