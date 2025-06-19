class CreditCardsController < ApplicationController
  def index
    @credit_cards = Current.user.accounts.where(kind: :credit_card)
  end

  def show
    @credit_card = Current.user.accounts.where(kind: :credit_card).find(params[:id])
    @month = params[:month].present? ? Date.parse(params[:month]) : default_month
    @statement = @credit_card.credit_card_statements.find_or_create_by(month: @month)
    @transactions = @credit_card.transactions.where(credit_card_statement: @statement).order(date: :desc)
  end

  private

  def default_month
    return Date.current.beginning_of_month if @credit_card.credit_card_expiration_day.nil?

    expiration_date = Date.current.change(day: @credit_card.credit_card_expiration_day)
    if expiration_date > Date.current
      Date.current.beginning_of_month
    else
      Date.current.beginning_of_month + 1.month
    end
  end
end
