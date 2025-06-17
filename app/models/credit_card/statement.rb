class CreditCard::Statement < ApplicationRecord
  belongs_to :account
end
