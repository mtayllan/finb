class SplitsController < ApplicationController
  before_action :set_split, only: %i[edit update destroy]

  def index
    @month = params[:month] ? Date.parse(params[:month]) : Date.current
    @splits_as_borrower = Current.user.splits_as_borrower.joins(:payer_transaction).where(transactions: {date: @month.all_month}).order(transactions: {date: :desc, created_at: :desc})
    @splits_as_payer = Current.user.splits_as_payer.joins(:payer_transaction).where(transactions: {date: @month.all_month}).order(transactions: {date: :desc, created_at: :desc})

    other_users = @splits_as_borrower.map { |split| split.payer_transaction.account.user_id }
    other_users += @splits_as_payer.map { |split| split.borrower_id }
    other_users.uniq!

    @summaries = other_users.map do |user_id|
      other_user = User.find(user_id)
      paid_by_user = @splits_as_borrower.joins(payer_transaction: :account).where(accounts: {user_id:})
      {
        other: other_user,
        other_spent: paid_by_user.sum(&:transaction_value),
        other_owed: @splits_as_payer.where(borrower_id: user_id).sum(:amount_borrowed),
        me_spent: @splits_as_payer.where(borrower_id: user_id).sum(&:transaction_value),
        me_owed: paid_by_user.sum(&:amount_borrowed)
      }
    end
  end

  def new
    session[:return_to_transactions] = params[:return_to_transactions].present?
    @split = Split.new(payer_transaction_id: params[:transaction_id])
  end

  def create
    @split = Split.new(split_params)
    if @split.save
      redirect_to after_save_path, notice: "Split was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    session[:return_to_transactions] = params[:return_to_transactions].present?
  end

  def update
    if @split.update(split_params)
      redirect_to after_save_path, notice: "Split was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @split.destroy
    redirect_to splits_path, notice: "Split was successfully deleted."
  end

  private

  def split_params
    params.require(:split).permit(:payer_transaction_id, :borrower_id, :amount_borrowed)
  end

  def set_split
    @split = Current.user.splits_as_payer.find(params[:id])
    if @split.confirmed_at?
      redirect_to splits_path, notice: "Cannot change confirmed split"
    end
  end

  def after_save_path
    if session[:return_to_transactions]
      transactions_path
    else
      splits_path
    end
  end
end
