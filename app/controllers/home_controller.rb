class HomeController < ApplicationController
  def index
    @month = params[:month] ? Date.parse(params[:month]) : Date.current
    month_range = @month.beginning_of_month..@month.end_of_month

    @accounts = Current.user.accounts.order(balance: :desc)
    @total_balance = @accounts.sum(:balance)
    @last_transactions = Current.user.transactions.order(date: :desc).limit(8)
    @last_transfers = Current.user.transfers.order(date: :desc).limit(8)

    @totals = calculate_expenses_from(month_range)
  end

  private

  def calculate_expenses_from(range)
    transactions = Current.user.transactions
    {
      total_income: transactions.where(date: range).where("value > 0").sum(:value),
      total_expenses: transactions.where(date: range).where("value < 0").sum(:value),
      expenses_by_category: transactions.where(date: range)
                                       .where("value < 0")
                                       .group(:category)
                                       .sum(:value)
                                       .sort_by { _1[1] }
                                       .to_h,
      income_by_category: transactions.where(date: range)
                                     .where("value > 0")
                                     .group(:category)
                                     .sum(:value)
                                     .sort_by { -_1[1] }
                                     .to_h
    }
  end
end
