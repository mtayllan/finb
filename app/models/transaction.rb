class Transaction < ApplicationRecord
  belongs_to :category
  belongs_to :account

  validates :value, :date, :description, presence: true
  validates :value, numericality: { other_than: 0 }
end
