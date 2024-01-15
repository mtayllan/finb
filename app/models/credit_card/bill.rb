class CreditCard::Bill < ApplicationRecord
  belongs_to :credit_card
  belongs_to :payment_account, class_name: 'Account', optional: true
end
