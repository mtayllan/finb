class Reports::IncomeByCategoriesController < ApplicationController
  def show
    month = Date.parse(params[:month])
    range = month.all_month
    account = Current.user.accounts.find(params[:account_id])

    @income_by_category = Transaction.where(date: range, account_id: account.id).where("value > 0")
      .group(:category).sum(:value).sort_by { -it[1] }.to_h
  end
end
