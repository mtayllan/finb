class Transaction < ApplicationRecord
  include Transaction::Installmentable

  belongs_to :category
  belongs_to :account, optional: true
  belongs_to :credit_card_statement, optional: true, class_name: "CreditCard::Statement"

  has_one :payer_split, class_name: "Split", foreign_key: "payer_transaction_id"
  has_one :borrower_split, class_name: "Split", foreign_key: "borrower_transaction_id", dependent: :nullify

  has_many :transaction_tags, dependent: :destroy
  has_many :tags, through: :transaction_tags

  validates :value, :date, :description, presence: true
  validates :value, numericality: {other_than: 0}
  validate :date_after_account_initial_balance_date

  attribute :credit_card_statement_month

  before_validation :set_credit_card_statement, if: :account
  before_save :set_report_value
  after_commit :update_account_balance, if: :account
  after_commit :update_credit_card_statement_value, if: :account

  def calculate_report_value
    return 0 if exclude_from_reports

    # use + because report_value is for expenses transactions and they are negative
    value + (payer_split&.amount_borrowed || 0)
  end

  def can_edit_split?
    payer_split && !payer_split.confirmed_at?
  end

  def can_create_split?
    value.negative? && payer_split.nil?
  end

  private

  def date_after_account_initial_balance_date
    return if account.nil? || date.nil?

    errors.add(:date, "must be after date of initial balance: #{account.initial_balance_date}") if date < account.initial_balance_date
  end

  def update_account_balance
    earliest_date = [date, date_previously_was].compact.min
    account.update_balance(start_date: earliest_date)

    previous_account_id = account_id_previously_was
    if previous_account_id
      Account.update_balance(previous_account_id, start_date: earliest_date)
    end
  end

  def update_credit_card_statement_value
    credit_card_statement&.update_value

    previous_credit_card_statement_id = credit_card_statement_id_previously_was
    if previous_credit_card_statement_id
      CreditCard::Statement.update_value(previous_credit_card_statement_id)
    end
  end

  def set_credit_card_statement
    return if credit_card_statement_month.blank?

    self.credit_card_statement = account.credit_card_statements.find_or_create_by(month: credit_card_statement_month)
  end

  def set_report_value
    self.report_value = calculate_report_value
  end
end
