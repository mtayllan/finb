class Tag < ApplicationRecord
  belongs_to :user

  has_many :transaction_tags, dependent: :destroy
  has_many :transactions, through: :transaction_tags, source: :taggable_transaction

  validates :name, presence: true, uniqueness: {scope: :user_id}
  validates :color, presence: true

  scope :by_last_usage, -> {
    left_joins(:transaction_tags)
      .group(:id)
      .order(Arel.sql("MAX(transaction_tags.created_at) IS NOT NULL, MAX(transaction_tags.created_at) DESC"))
  }
end
