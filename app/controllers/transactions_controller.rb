class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ edit update destroy ]

  def index
    @month = params[:month] ? Date.parse(params[:month]) : Date.current
    filter = { date: @month.beginning_of_month..@month.end_of_month }
    filter[:account_id] = params[:account_id] if params[:account_id]
    filter[:category_id] = params[:category_id] if params[:category_id]
    @transactions = Transaction.includes(:category, :account).where(filter).order(date: :desc, created_at: :desc)
  end

  def new
    @transaction = Transaction.new(account_id: params[:account_id])
  end

  def edit
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      @transaction.account.update_balance
      redirect_to account_url(@transaction.account), notice: "Transaction was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      @transaction.account.update_balance
      redirect_to account_url(@transaction.account), notice: "Transaction was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy!
    @transaction.account.update_balance

    redirect_to account_url(@transaction.account), notice: "Transaction was successfully destroyed."
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
