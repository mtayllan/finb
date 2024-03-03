class Reports::DailyBalancesController < ApplicationController
  def show
    account_id = params[:account_id]
    @balances = Account::Balance.where(account_id: account_id).order(date: :asc).pluck(:date, :balance)
  end
end
