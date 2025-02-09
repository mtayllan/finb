class CreditCard::Payment < ApplicationRecord
  belongs_to :statement
  belongs_to :account
end
