class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[edit update destroy]

  def index
    @month = params[:month] ? Date.parse(params[:month]) : Date.current
    filter = {date: @month.all_month}
    filter[:account_id] = params[:account_id] if params[:account_id]
    filter[:category_id] = params[:category_id] if params[:category_id]
    @transactions = Current.user.transactions.includes(:category, :account, :payer_split, :tags).where(filter).order(date: :desc, created_at: :desc)
  end

  def new
    @transaction = Transaction.new(account_id: params[:account_id])
  end

  def edit
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.valid?
      installments = params[:transaction][:installments].to_i
      Transaction.create_with_installments(@transaction, installments)

      redirect_to after_save_url(@transaction), notice: "Transaction was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to after_save_url(@transaction), notice: "Transaction was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @transaction.destroy!

    redirect_to after_save_url(@transaction), notice: "Transaction was successfully destroyed."
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    if params[:transaction][:transaction_type] == "expense"
      params[:transaction][:value] = "-#{params[:transaction][:value]}"
    end
    params.require(:transaction).permit(:description, :value, :category_id, :account_id, :date, :credit_card_statement_month, :exclude_from_reports, tag_ids: [])
  end

  def after_save_url(transaction)
    if transaction.credit_card_statement
      credit_card_url(transaction.account, month: transaction.credit_card_statement.month.strftime("%Y/%m"))
    else
      account_url(transaction.account)
    end
  end
end
