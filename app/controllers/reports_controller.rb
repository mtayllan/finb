class ReportsController < ApplicationController
  include DateRangeFilterable

  def show
    apply_quick_filter if params[:quick_filter].present?

    @start_date = begin
      Date.parse(params[:start_date])
    rescue
      Date.current.beginning_of_month
    end
    @end_date = begin
      Date.parse(params[:end_date])
    rescue
      Date.current.end_of_month
    end

    @granularity = params[:granularity].presence || "total"
    @categories = Current.user.categories.order(:name)
    @accounts = Current.user.accounts.order(:name)
    @tags = Current.user.tags.by_last_usage

    @selected_category_id = params[:category_id]
    @selected_account_id = params[:account_id]
    @selected_tag_ids = Array(params[:tag_ids]).compact_blank
    @excluded_tag_ids = Array(params[:excluded_tag_ids]).compact_blank

    transactions = Current.user.transactions.where(date: @start_date..@end_date)
    transactions = transactions.where(exclude_from_reports: false)
    transactions = transactions.where(category_id: @selected_category_id) if @selected_category_id.present?
    transactions = transactions.where(account_id: @selected_account_id) if @selected_account_id.present?
    transactions = transactions.joins(:tags).where(tags: {id: @selected_tag_ids}).distinct if @selected_tag_ids.any?
    if @excluded_tag_ids.any?
      excluded_transaction_ids = TransactionTag.where(tag_id: @excluded_tag_ids).select(:transaction_id)
      transactions = transactions.where.not(id: excluded_transaction_ids)
    end

    if @granularity == "total"
      @total_income = transactions.where("value > 0").sum(:value)
      # Use report_value because of splits but only on expenses as there are no splits for income transactions
      @total_expenses = transactions.where("value < 0").sum(:report_value)
    else
      @income_by_period = transactions.where("value > 0").group_by_period(@granularity, :date, range: @start_date..@end_date).sum(:value)
      @expenses_by_period = transactions.where("value < 0").group_by_period(@granularity, :date, range: @start_date..@end_date).sum(:report_value)

      @total_income = @income_by_period.values.sum
      @total_expenses = @expenses_by_period.values.sum
    end

    @net_total = @total_income + @total_expenses

    # reminder: we do no use report_value for @account_totals because splits are only for expenses
    @category_totals = transactions.group_by(&:category).map { |k, v| [k, v.sum(&:report_value)] }.sort_by { |_, v| v.abs }.reverse.to_h
    @account_totals = transactions.joins(:account).group(:account).sum(:value).sort_by { |_, v| v.abs }.reverse.to_h
    tagged_transactions = transactions.joins(:tags).includes(:tags)
    @tag_totals = tagged_transactions.flat_map { |t| t.tags.map { |tag| [tag, t.report_value] } }
      .group_by(&:first)
      .transform_values { |pairs| pairs.sum(&:last) }
      .sort_by { |_, v| v.abs }
      .reverse
      .to_h

    # For backwards compatibility with the chart
    @income = @income_by_period || {}
    @expenses = @expenses_by_period || {}
  end
end
