class CreditCardsController < ApplicationController
  before_action :set_credit_card, only: %i[ show edit update destroy ]

  def index
    @credit_cards = CreditCard.all
  end

  def show
  end

  def new
    @credit_card = CreditCard.new
  end

  def edit
  end

  def create
    @credit_card = CreditCard.new(credit_card_params)

    if @credit_card.save
      redirect_to credit_card_url(@credit_card), notice: "Credit card was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @credit_card.update(credit_card_params)
      redirect_to credit_card_url(@credit_card), notice: "Credit card was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @credit_card.destroy!

    redirect_to credit_cards_url, notice: "Credit card was successfully destroyed."
  end

  private
    def set_credit_card
      @credit_card = CreditCard.find(params[:id])
    end

    def credit_card_params
      params.require(:credit_card).permit(:name, :due_day, :close_day, :color)
    end
end
