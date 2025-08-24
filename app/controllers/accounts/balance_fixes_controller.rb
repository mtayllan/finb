class Accounts::BalanceFixesController < ApplicationController
  before_action :set_account

  def new
    @transaction = Transaction.new
    @categories = Current.user.categories.order(:name)
  end

  def create
    correct_balance = BigDecimal(params[:balance_fix][:correct_balance])
    diff = correct_balance - @account.balance

    @transaction = Transaction.new(
      account: @account,
      description: params[:transaction][:description],
      category_id: params[:transaction][:category_id],
      value: diff,
      date: Date.current
    )

    if @transaction.save
      redirect_to account_path(@account), notice: "Account balance was successfully fixed."
    else
      @categories = Current.user.categories.order(:name)
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_account
    @account = Current.user.accounts.find(params[:account_id])
  end
end
