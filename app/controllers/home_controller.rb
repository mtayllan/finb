class HomeController < ApplicationController
  def index
    current_month = Date.today.beginning_of_month..Date.today.end_of_month
    last_month = Date.today.prev_month.beginning_of_month..Date.today.prev_month.end_of_month

    @accounts = Account.order(balance: :desc)
    @total_balance = @accounts.sum(:balance)
    @last_transactions = Transaction.order(date: :desc).limit(8)
    @last_transfers = Transfer.order(date: :desc).limit(8)

    @totals = {
      current_month: calculate_expenses_from(current_month),
      last_month: calculate_expenses_from(last_month)
    }
  end

  private

  def calculate_expenses_from(range)
    {
      total_income: Transaction.where(date: range).where("value > 0").sum(:value),
      total_expenses: Transaction.where(date: range).where("value < 0").sum(:value),
      expenses_by_category: Transaction.where(date: range)
                                       .where("value < 0")
                                       .group(:category)
                                       .sum(:value)
                                       .sort_by { _1[1] }
                                       .to_h,
      income_by_category: Transaction.where(date: range)
                                     .where("value > 0")
                                     .group(:category)
                                     .sum(:value)
                                     .sort_by { -_1[1] }
                                     .to_h
    }
  end
end
