class CreditCardsController < ApplicationController
  before_action :set_credit_card, only: %i[ show edit update destroy ]

  def index
    @credit_cards = Current.user.credit_cards.order(:name)
  end

  def show
    @month = params[:month] ? Date.parse(params[:month]) : Date.current
    @statement = @credit_card.statements.find_by_month(@month)
    @transactions = @statement ? @statement.transactions.order(:date) : []
  end

  def new
    @credit_card = CreditCard.new
  end

  def edit
  end

  def create
    @credit_card = CreditCard.new(credit_card_params)
    @credit_card.user = Current.user

    if @credit_card.save
      redirect_to credit_cards_url(@credit_card), notice: "Credit Card was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @credit_card.update(credit_card_params)
      redirect_to credit_cards_url(@credit_card), notice: "Credit Card was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @credit_card.destroy!

    redirect_to credit_cards_url, notice: "Credit Card was successfully destroyed."
  end

  private

  def set_credit_card
    @credit_card = Current.user.credit_cards.find(params[:id])
  end

  def credit_card_params
    params.require(:credit_card).permit(:name, :limit, :closing_day, :due_day, :color)
  end
end
