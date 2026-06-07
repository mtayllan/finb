module DateRangeFilterable
  extend ActiveSupport::Concern

  private

  def apply_quick_filter
    case params[:quick_filter]
    when "today"
      params[:start_date] = Date.current.to_s
      params[:end_date] = Date.current.to_s
    when "this_week"
      params[:start_date] = Date.current.beginning_of_week.to_s
      params[:end_date] = Date.current.end_of_week.to_s
    when "last_week"
      params[:start_date] = 1.week.ago.beginning_of_week.to_s
      params[:end_date] = 1.week.ago.end_of_week.to_s
    when "last_2_weeks"
      params[:start_date] = 2.weeks.ago.to_date.to_s
      params[:end_date] = Date.current.to_s
    when "this_month"
      params[:start_date] = Date.current.beginning_of_month.to_s
      params[:end_date] = Date.current.end_of_month.to_s
    when "last_month"
      params[:start_date] = 1.month.ago.beginning_of_month.to_s
      params[:end_date] = 1.month.ago.end_of_month.to_s
    when "last_3_months"
      params[:start_date] = 3.months.ago.to_date.to_s
      params[:end_date] = Date.current.to_s
    when "this_year"
      params[:start_date] = Date.current.beginning_of_year.to_s
      params[:end_date] = Date.current.end_of_year.to_s
    end
  end
end
