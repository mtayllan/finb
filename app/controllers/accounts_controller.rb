class AccountsController < ApplicationController
  before_action :set_account, only: %i[ edit update destroy ]

  def index
    @accounts = Account.all.order(:name)
  end

  def show
  end

  def new
    @account = Account.new
  end

  def edit
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      @account.update_balance
      redirect_to accounts_url, notice: "Account was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @account.update(account_params)
      @account.update_balance
      redirect_to accounts_url, notice: "Account was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy!

    redirect_to accounts_url, notice: "Account was successfully destroyed."
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :initial_balance, :balance)
  end
end
