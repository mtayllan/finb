class CreditCard::TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ edit update destroy ]

  def new
    @transaction = CreditCard::Transaction.new
  end

  def edit
  end

  def create
    @transaction = CreditCard::Transaction.new(transaction_params)
    credit_card = Current.user.credit_cards.find(params[:credit_card_transaction][:credit_card_id])
    month = Date.parse(params[:credit_card_transaction][:statement_month])
    @transaction.statement = credit_card.statements.find_or_create_by_month(month, credit_card:)

    if @transaction.save
      redirect_to credit_card_url(credit_card), notice: "Transaction was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @transaction.assign_attributes(transaction_params)
    credit_card = Current.user.credit_cards.find(params[:credit_card_transaction][:credit_card_id])
    month = Date.parse(params[:credit_card_transaction][:statement_month])
    @transaction.statement = credit_card.statements.find_or_create_by_month(month, credit_card:)

    if @transaction.save
      redirect_to credit_card_url(credit_card), notice: "Transaction was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy!

    redirect_to credit_card_url(@transaction.credit_card), notice: "Transaction was successfully destroyed."
  end

  private

  def set_transaction
    @transaction = Current.user.credit_card_transactions.find(params[:id])
  end

  def transaction_params
    params.require(:credit_card_transaction).permit(:description, :value, :date, :category_id, :total_installments)
  end
end
