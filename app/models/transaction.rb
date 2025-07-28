class Transaction < ApplicationRecord
  include Transaction::Installmentable

  belongs_to :category
  belongs_to :account
  belongs_to :credit_card_statement, optional: true, class_name: "CreditCard::Statement"

  has_many :splits, foreign_key: "source_transaction_id", dependent: :destroy

  validates :value, :date, :description, presence: true
  validates :value, numericality: {other_than: 0}
  validate :date_after_account_initial_balance_date

  attribute :credit_card_statement_month

  before_validation :set_credit_card_statement
  after_commit :update_account_balance
  after_commit :update_credit_card_statement_value

  def final_value
    # Se há splits onde esta transação é de quem pagou, subtrair o total dividido
    splits_as_payer = splits.where(payer_id: account.user_id)
    return value unless splits_as_payer.any?
    
    value - splits_as_payer.sum(:amount_owed)
  end

  def has_split?
    splits.any?
  end

  def splittable?
    # Transações negativas podem sempre ter novos splits criados
    value < 0
  end

  private

  def date_after_account_initial_balance_date
    return if account.nil? || date.nil?

    errors.add(:date, "must be after date of initial balance: #{account.initial_balance_date}") if date < account.initial_balance_date
  end

  def update_account_balance
    account.update_balance

    previous_account_id = account_id_previously_was
    if previous_account_id
      Account.update_balance(previous_account_id)
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
    return if credit_card_statement_month.blank? || account.nil?

    self.credit_card_statement = account.credit_card_statements.find_or_create_by(month: credit_card_statement_month)
  end
end
