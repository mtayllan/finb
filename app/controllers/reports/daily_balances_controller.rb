class Reports::DailyBalancesController < ApplicationController
  def show
    account = Current.user.accounts.find(params[:account_id])
    @balances = Account::Balance.where(account_id: account.id).order(date: :asc).pluck(:date, :balance)
  end
end
