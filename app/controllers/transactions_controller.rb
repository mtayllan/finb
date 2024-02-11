class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ edit update destroy ]

  def index
    @month = params[:month] ? Date.parse(params[:month]) : Date.current
    @transactions = Transaction.includes(:category, :account).where(date: @month.beginning_of_month..@month.end_of_month).order(date: :desc, created_at: :desc)
    @transactions = @transactions.where(account_id: params[:account_id]) if params[:account_id].present?
    @transactions = @transactions.where(category_id: params[:category_id]) if params[:category_id].present?
  end

  def new
    @transaction = Transaction.new
  end

  def edit
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      @transaction.account.update_balance
      redirect_to transactions_url, notice: "Transaction was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      @transaction.account.update_balance
      redirect_to transactions_url, notice: "Transaction was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy!
    @transaction.account.update_balance

    redirect_to transactions_url, notice: "Transaction was successfully destroyed."
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    if params[:transaction][:transaction_type] == "expense"
      params[:transaction][:value] = "-#{params[:transaction][:value]}"
    end
    params.require(:transaction).permit(:description, :value, :category_id, :account_id, :date)
  end
end
