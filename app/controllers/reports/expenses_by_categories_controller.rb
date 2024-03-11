class Reports::ExpensesByCategoriesController < ApplicationController
  def show
    month = Date.parse(params[:month])
    range = month.beginning_of_month..month.end_of_month
    account_id = params[:account_id]

    @expenses_by_category = Transaction.where(date: range, account_id:).where("value < 0")
                                      .group(:category).sum(:value).sort_by { _1[1] }.to_h
  end
end
