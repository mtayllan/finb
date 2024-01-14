class HomeController < ApplicationController
  def index
    @total_income_this_month = Transaction.where(date: Date.today.beginning_of_month..Date.today.end_of_month).where('value > 0').sum(:value)
    @total_expenses_this_month = Transaction.where(date: Date.today.beginning_of_month..Date.today.end_of_month).where('value < 0').sum(:value)

    @expenses_by_category_this_month =
      Transaction.where(date: Date.today.beginning_of_month..Date.today.end_of_month)
                 .where('value < 0')
                 .group(:category)
                 .sum(:value)
                 .sort_by { _1[1] }
                 .to_h

    @income_by_category_this_month =
      Transaction.where(date: Date.today.beginning_of_month..Date.today.end_of_month)
                .where('value > 0')
                .group(:category)
                .sum(:value)
                .sort_by { -_1[1] }
                .to_h
  end
end
