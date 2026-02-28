class CreditCardsController < ApplicationController
  def index
    @credit_cards = Current.user.accounts
      .where(kind: :credit_card)
      .map { |card| Account::CreditCardSummary.new(card) }
  end

  def show
    @credit_card = Current.user.accounts.where(kind: :credit_card).find(params[:id])
    @month = params[:month].present? ? Date.parse(params[:month]) : Account::CreditCardSummary.new(@credit_card).billing_month
    @statement = @credit_card.credit_card_statements.find_or_create_by(month: @month)
    @transactions = @credit_card.transactions.includes(:tags).where(credit_card_statement: @statement).order(date: :desc)
  end
end
