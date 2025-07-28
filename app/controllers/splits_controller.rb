# frozen_string_literal: true

class SplitsController < ApplicationController
  before_action :set_current_user_splits, only: [:index]

  def index
    @tab = params[:tab] || "from_me"

    @splits = case @tab
    when "from_me"
      @current_user_splits.splits_as_payer
    when "to_me"
      @current_user_splits.splits_as_owes_to
    when "summary"
      @current_user_splits.all_splits
    else
      @current_user_splits.splits_as_payer
    end

    @splits = @splits.includes(:source_transaction, :payer, :owes_to, :owes_to_category)
      .order(created_at: :desc)

    # Calculate summary data for cards
    if @tab == "summary"
      @splits_summary = calculate_splits_summary
    end

    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace("splits_content", partial: "splits_table") }
    end
  end

  def show
    @split = Current.user.all_splits.find(params[:id])
  end

  def edit
    @split = Current.user.all_splits.find(params[:id])
  end

  def update
    @split = Current.user.all_splits.find(params[:id])

    if @split.update(split_params)
      redirect_to splits_path, notice: "Split atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @split = Current.user.all_splits.find(params[:id])
    @split.destroy

    respond_to do |format|
      format.html { redirect_to splits_path, notice: "Split removido com sucesso." }
      format.turbo_stream { redirect_to splits_path(tab: params[:tab]) }
    end
  end

  def mark_as_paid
    @split = Current.user.all_splits.find(params[:id])
    @split.mark_as_paid!

    respond_to do |format|
      format.html { redirect_to splits_path, notice: "Split marcado como pago." }
      format.turbo_stream { redirect_to splits_path(tab: params[:tab]) }
    end
  end

  private

  def set_current_user_splits
    @current_user_splits = Current.user
  end

  def split_params
    params.require(:split).permit(:amount_owed, :owes_to_category_id, :paid_at)
  end

  def calculate_splits_summary
    @current_user_splits.splits_summary
  end
end
