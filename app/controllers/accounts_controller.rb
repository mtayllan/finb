class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update destroy ]

  def index
    @accounts = Account.all.order(:name)
  end

  def show
    @month = params[:month] ? Date.parse(params[:month]) : Date.current
    filter = { date: @month.beginning_of_month..@month.end_of_month }
    filter[:category_id] = params[:category_id] if params[:category_id]
    transactions = Transaction.includes(:category).where(filter).order(date: :desc, created_at: :desc)
    transfers = [] if filter[:category_id]
    transfers ||= Transfer.includes(:origin_account, :target_account)
                        .where(date: filter[:date])
                        .where("(origin_account_id = :account_id OR target_account_id = :account_id)", account_id: @account.id)
                        .order(date: :desc, created_at: :desc)

    @transactions_and_transfers = (transactions + transfers).sort_by(&:date).reverse
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
    params.require(:account).permit(:name, :initial_balance, :balance, :color)
  end
end
