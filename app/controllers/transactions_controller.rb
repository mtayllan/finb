class TransactionsController < ApplicationController
  include Pagy::Backend

  before_action :set_transaction, only: %i[ edit update destroy ]

  def index
    @pagination, @transactions = pagy(Transaction.order(date: :desc))
  end

  def new
    @transaction = Transaction.new
    set_categories_and_accounts
  end

  def edit
    set_categories_and_accounts
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      @transaction.account.update_balance
      redirect_to transactions_url, notice: "Transaction was successfully created."
    else
      set_categories_and_accounts
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      @transaction.account.update_balance
      redirect_to transactions_url, notice: "Transaction was successfully updated."
    else
      set_categories_and_accounts
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy!
    @transaction.account.update_balance

    redirect_to transactions_url, notice: "Transaction was successfully destroyed."
  end

  private

  def set_categories_and_accounts
    @all_categories = Category.all.order(:name)
    @all_accounts = Account.all.order(:name)
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:description, :value, :category_id, :account_id, :date)
  end
end
