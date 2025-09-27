class TransfersController < ApplicationController
  before_action :set_transfer, only: %i[edit update destroy]

  def index
    @month = params[:month] ? Date.parse(params[:month]) : Date.current
    @transfers = Current.user.transfers.includes(:origin_account, :target_account).where(date: @month.all_month).order(date: :desc, created_at: :desc)
  end

  def new
    @transfer = Transfer.new
  end

  def edit
  end

  def create
    @transfer = Transfer.new(transfer_params)

    if @transfer.save
      @transfer.origin_account.update_balance(start_date: @transfer.date)
      @transfer.target_account.update_balance(start_date: @transfer.date)
      redirect_to transfers_url, notice: "Transfer was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @transfer.update(transfer_params)
      earliest_date = [@transfer.date, @transfer.date_previously_was].compact.min
      @transfer.origin_account.update_balance(start_date: earliest_date)
      @transfer.target_account.update_balance(start_date: earliest_date)
      if @transfer.origin_account_id_previously_changed?
        Account.update_balance(@transfer.origin_account_id_previously_was, start_date: earliest_date)
      end
      if @transfer.target_account_id_previously_changed?
        Account.update_balance(@transfer.target_account_id_previously_was, start_date: earliest_date)
      end
      redirect_to transfers_url, notice: "Transfer was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    transfer_date = @transfer.date
    @transfer.destroy!
    @transfer.origin_account.update_balance(start_date: transfer_date)
    @transfer.target_account.update_balance(start_date: transfer_date)

    redirect_to transfers_url, notice: "Transfer was successfully destroyed."
  end

  private

  def set_transfer
    @transfer = Current.user.transfers.find(params[:id])
  end

  def transfer_params
    params.require(:transfer).permit(:origin_account_id, :target_account_id, :value, :date, :description)
  end
end
