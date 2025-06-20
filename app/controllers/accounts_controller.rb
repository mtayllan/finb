class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]

  def index
    @grouped_accounts = Current.user.accounts.order(:name).group_by(&:kind)
  end

  def show
    respond_to do |format|
      format.html do
        @month = params[:month] ? Date.parse(params[:month]) : Date.current
        filter = {date: @month.all_month}
        filter[:category_id] = params[:category_id] if params[:category_id]
        filter[:account_id] = @account.id
        transactions = Transaction.includes(:category).where(filter).order(date: :desc, created_at: :desc)
        transfers = [] if filter[:category_id]
        transfers ||= Transfer.includes(:origin_account, :target_account)
          .where(date: filter[:date])
          .where("(origin_account_id = :account_id OR target_account_id = :account_id)", account_id: @account.id)
          .order(date: :desc, created_at: :desc)
        balances = @account.balances.where(date: filter[:date]).order(date: :desc)

        @account_events = (transactions + transfers + balances).sort_by(&:date).reverse
      end

      format.json do
        render json: @account
      end
    end
  end

  def new
    @account = Account.new
  end

  def edit
  end

  def create
    @account = Account.new(account_params)
    @account.user = Current.user

    if @account.save
      @account.update_balance
      redirect_to accounts_url(@account), notice: "Account was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @account.update(account_params)
      @account.update_balance
      redirect_to accounts_url(@account), notice: "Account was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy!
    Current.user.accounts.each(&:update_balance)

    redirect_to accounts_url, notice: "Account was successfully destroyed."
  end

  private

  def set_account
    @account = Current.user.accounts.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :initial_balance, :initial_balance_date, :color, :kind, :credit_card_expiration_day)
  end
end
