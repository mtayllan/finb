class TransfersController < ApplicationController
  before_action :set_transfer, only: %i[ edit update destroy ]

  def index
    @month = params[:month] ? Date.parse(params[:month]) : Date.current
    @transfers = Transfer.includes(:origin_account, :target_account).where(date: @month.beginning_of_month..@month.end_of_month).order(date: :desc, created_at: :desc)
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
      redirect_to transfers_url, notice: "Transfer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @transfer.update(transfer_params)
      @transfer.origin_account.update_balance
      @transfer.target_account.update_balance
      redirect_to transfers_url, notice: "Transfer was successfully updated."
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
