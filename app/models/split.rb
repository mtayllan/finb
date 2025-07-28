class Split < ApplicationRecord
  belongs_to :source_transaction, class_name: "Transaction"
  belongs_to :payer, class_name: "User"
  belongs_to :owes_to, class_name: "User"
  belongs_to :owes_to_category, class_name: "Category", optional: true

  validates :amount_owed, presence: true, numericality: {greater_than: 0}
  validates :source_transaction_id, uniqueness: true

  validate :users_must_be_different
  validate :amount_cannot_exceed_transaction_value
  validate :owes_to_category_belongs_to_owes_to_user

  scope :paid, -> { where.not(paid_at: nil) }
  scope :unpaid, -> { where(paid_at: nil) }

  def paid?
    paid_at.present?
  end

  def mark_as_paid!
    update!(paid_at: Time.current)
  end

  def mark_as_unpaid!
    update!(paid_at: nil)
  end

  private

  def users_must_be_different
    return unless payer_id && owes_to_id

    errors.add(:owes_to, "can't be the same as payer") if payer_id == owes_to_id
  end

  def amount_cannot_exceed_transaction_value
    return unless source_transaction && amount_owed

    if amount_owed > source_transaction.value.abs
      errors.add(:amount_owed, "can't exceed transaction value")
    end
  end

  def owes_to_category_belongs_to_owes_to_user
    return unless owes_to_category && owes_to

    unless owes_to_category.user_id == owes_to_id
      errors.add(:owes_to_category, "must belong to the person who owes")
    end
  end
end
