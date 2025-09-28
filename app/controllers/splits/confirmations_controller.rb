class Splits::ConfirmationsController < ApplicationController
  before_action :set_split

  def create
    if @split.confirmed_at?
      redirect_to splits_path, alert: "Split has already been confirmed" and return
    end

    transaction = Transaction.create!(
      description: @split.payer_transaction.description,
      category_id: params[:category_id],
      value: -@split.amount_borrowed,
      date: @split.payer_transaction.date
    )
    @split.update!(borrower_transaction: transaction, confirmed_at: Date.current)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("split_#{@split.id}", partial: "splits/borrower_row", locals: {split: @split}) }
      format.html { redirect_to splits_path, notice: "Split confirmed!" }
    end
  end

  def destroy
    if !@split.confirmed_at?
      redirect_to splits_path, alert: "Split has not been confirmed" and return
    end

    @split.borrower_transaction.destroy!
    @split.update(confirmed_at: nil)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("split_#{@split.id}", partial: "splits/borrower_row", locals: {split: @split}) }
      format.html { redirect_to splits_path, notice: "Split unconfirmed!" }
    end
  end

  private

  def set_split
    @split = Current.user.splits_as_borrower.find(params[:split_id])
  end
end
