class HomeController < ApplicationController
  def index
    current_month = Date.today.beginning_of_month..Date.today.end_of_month

    @total_income_this_month = Transaction.where(date: current_month).where('value > 0').sum(:value)
    @total_expenses_this_month = Transaction.where(date: current_month).where('value < 0').sum(:value)

    @expenses_by_category_this_month =
      Transaction.where(date: current_month)
                 .where('value < 0')
                 .group(:category)
                 .sum(:value)
                 .sort_by { _1[1] }
                 .to_h

    @income_by_category_this_month =
      Transaction.where(date: current_month)
                .where('value > 0')
                .group(:category)
                .sum(:value)
                .sort_by { -_1[1] }
                .to_h

    last_tree_months = (Date.today - 3.months).beginning_of_month..(Date.today - 1.month).end_of_month

    @total_income_last_three = Transaction.where(date: last_tree_months).where('value > 0').sum(:value)
    @total_expenses_last_three = Transaction.where(date: last_tree_months).where('value < 0').sum(:value)

    @expenses_by_category_last_three =
      Transaction.where(date: last_tree_months)
                  .where('value < 0')
                  .group(:category)
                  .sum(:value)
                  .sort_by { _1[1] }
                  .to_h

    @income_by_category_last_three =
      Transaction.where(date: last_tree_months)
                .where('value > 0')
                .group(:category)
                .sum(:value)
                .sort_by { -_1[1] }
                .to_h
  end
end
