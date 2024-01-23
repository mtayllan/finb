class TransfersController < ApplicationController
  before_action :set_transfer, only: %i[ show edit update destroy ]

  def index
    @transfers = Transfer.all.order(date: :desc)
  end

  def show
  end

  def new
    @transfer = Transfer.new
  end

  def edit
  end

  def create
    @transfer = Transfer.new(transfer_params)

    if @transfer.save
      @transfer.origin_account.update_balance
      @transfer.target_account.update_balance
      redirect_to transfer_url(@transfer), notice: "Transfer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @transfer.update(transfer_params)
      @transfer.origin_account.update_balance
      @transfer.target_account.update_balance
      redirect_to transfer_url(@transfer), notice: "Transfer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transfer.destroy!
    @transfer.origin_account.update_balance
    @transfer.target_account.update_balance

    redirect_to transfers_url, notice: "Transfer was successfully destroyed."
  end

  private
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    def transfer_params
      params.require(:transfer).permit(:origin_account_id, :target_account_id, :value, :date, :description)
    end
end
