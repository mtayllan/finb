class TransactionsController < ApplicationController
  include DateRangeFilterable

  before_action :set_transaction, only: %i[edit update destroy]

  PER_PAGE = 20

  def index
    apply_quick_filter if params[:quick_filter].present?

    @start_date = begin
      Date.parse(params[:start_date])
    rescue
      nil
    end
    @end_date = begin
      Date.parse(params[:end_date])
    rescue
      nil
    end

    @categories = Current.user.categories.order(:name)
    @accounts = Current.user.accounts.order(:name)
    @tags = Current.user.tags.by_last_usage

    @selected_category_id = params[:category_id]
    @selected_account_id = params[:account_id]
    @selected_tag_ids = Array(params[:tag_ids]).compact_blank

    @page = params[:page].to_i

    transactions = Current.user.transactions.includes(:category, :account, :payer_split, :tags)
    transactions = transactions.where(category_id: @selected_category_id) if @selected_category_id.present?
    transactions = transactions.where(account_id: @selected_account_id) if @selected_account_id.present?
    transactions = transactions.joins(:tags).where(tags: {id: @selected_tag_ids}).distinct if @selected_tag_ids.any?
    transactions = transactions.where("LOWER(description) LIKE LOWER(?)", "%#{params[:search]}%") if params[:search].present?

    if @start_date || @end_date
      paginate_by_date_range(transactions)
    elsif @page > 0
      paginate_future(transactions)
    else
      paginate_past(transactions)
    end
  end

  def new
    @transaction = Transaction.new(account_id: params[:account_id], transaction_type: params[:transaction_type])
  end

  def edit
    session[:transaction_return_to] = request.referer
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.valid?
      installments = params[:transaction][:installments].to_i
      Transaction.create_with_installments(@transaction, installments)

      redirect_to after_save_url(@transaction), notice: "Transaction was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to after_save_url(@transaction), notice: "Transaction was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @transaction.destroy!

    redirect_to after_save_url(@transaction), notice: "Transaction was successfully destroyed."
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    if params[:transaction][:transaction_type] == "expense"
      params[:transaction][:value] = "-#{params[:transaction][:value]}"
    end
    params.require(:transaction).permit(:description, :value, :category_id, :account_id, :date, :credit_card_statement_month, :exclude_from_reports, tag_ids: [])
  end

  # A date range is active: page 1 is the newest match, paging forward goes older.
  def paginate_by_date_range(transactions)
    @page = 1 if @page < 1
    transactions = transactions.where(date: @start_date..) if @start_date
    transactions = transactions.where(date: ..@end_date) if @end_date
    transactions = transactions.order(date: :desc, created_at: :desc)

    @transactions = transactions.limit(PER_PAGE).offset((@page - 1) * PER_PAGE)
    @newer_page = @page - 1
    @older_page = @page + 1
  end

  # page > 0: future transactions, fetched oldest-first then reversed so the view stays newest-first.
  def paginate_future(transactions)
    @transactions = transactions.where("date > ?", Date.current)
      .order(date: :asc, created_at: :asc)
      .limit(PER_PAGE)
      .offset((@page - 1) * PER_PAGE)
      .reverse
    @newer_page = @page + 1
    @older_page = @page - 1
  end

  # page <= 0: today and past, newest-first. Offset grows as the page number goes more negative.
  def paginate_past(transactions)
    @transactions = transactions.where(date: ..Date.current)
      .order(date: :desc, created_at: :desc)
      .limit(PER_PAGE)
      .offset(-@page * PER_PAGE)
    @newer_page = @page + 1
    @older_page = @page - 1
  end

  def after_save_url(transaction)
    return session.delete(:transaction_return_to) || transactions_url unless transaction.account

    if transaction.credit_card_statement
      credit_card_url(transaction.account, month: transaction.credit_card_statement.month.strftime("%Y/%m"))
    else
      account_url(transaction.account)
    end
  end
end
