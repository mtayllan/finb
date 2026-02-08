class HomeController < ApplicationController
  def index
    @month = params[:month] ? Date.parse(params[:month]) : Date.current
    month_range = @month.all_month
    prev_month_range = @month.prev_month.all_month

    # Account balances
    @accounts = Current.user.accounts.order(balance: :desc).limit(5)
    @total_balance = Current.user.accounts.sum(:balance)

    # Previous month balance for trend calculation
    prev_month_balance = calculate_balance_at(prev_month_range.end)
    @balance_change = @total_balance - prev_month_balance
    @balance_change_percent = prev_month_balance.zero? ? 0 : ((@balance_change / prev_month_balance.abs) * 100).round(2)

    # Recent transactions (combined transactions and transfers)
    @last_transactions = Current.user.transactions.where(date: ..Date.current).order(date: :desc).limit(5)

    # Monthly totals
    @totals = calculate_expenses_from(month_range)

    # Top 5 expense categories with percentages
    total_expenses = @totals[:total_expenses].abs
    @top_categories = @totals[:expenses_by_category]
      .first(5)
      .map do |category, value|
        {
          category: category,
          amount: value,
          percentage: total_expenses.zero? ? 0 : ((value.abs / total_expenses) * 100).round(0)
        }
      end
  end

  private

  def calculate_balance_at(date)
    # Calculate total balance at a specific date
    Current.user.accounts.sum do |account|
      # Start with current balance and subtract transactions after the date
      account.balance - account.transactions.where("date > ?", date).sum(:value)
    end
  end

  def calculate_expenses_from(range)
    transactions = Current.user.transactions
    {
      total_income: transactions.where(date: range).where("value > 0").sum(:value),
      total_expenses: transactions.where(date: range).where("value < 0").sum(&:report_value),
      expenses_by_category: transactions.where(date: range)
        .where("value < 0")
        .group_by(&:category)
        .map { |k, v| [k, v.sum(&:report_value)] }
        .sort_by { it[1] }
        .to_h,
      income_by_category: transactions.where(date: range)
        .where("value > 0")
        .group(:category)
        .sum(:value)
        .sort_by { -it[1] }
        .to_h
    }
  end
end
