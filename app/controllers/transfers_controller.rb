class TransfersController < ApplicationController
  before_action :set_transfer, only: %i[ show edit update destroy ]

  def index
    @transfers = Transfer.all
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
      redirect_to transfer_url(@transfer), notice: "Transfer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transfers/1 or /transfers/1.json
  def update
    if @transfer.update(transfer_params)
      redirect_to transfer_url(@transfer), notice: "Transfer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /transfers/1 or /transfers/1.json
  def destroy
    @transfer.destroy!

    redirect_to transfers_url, notice: "Transfer was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transfer_params
      params.require(:transfer).permit(:origin_account_id, :target_account_id, :value, :date, :description)
    end
end
