class ApplicationController < ActionController::Base
  before_action :authenticate
  before_action :recalculate_balances

  def authenticate
    if (user_session = Session.find_by(token: cookies.signed[:session_token]))
      Current.user = user_session.user
    else
      session[:return_to_after_authenticating] = request.url
      redirect_to new_sessions_path, alert: "Please sign in"
    end
  end

  def recalculate_balances
    return unless Current.user
    last_calc_date = Rails.cache.fetch("last_balance_calculation_date/#{Current.user.id}") do
      Current.user.accounts.minimum(:updated_at)&.to_date
    end

    return unless last_calc_date

    if last_calc_date < Date.current
      Current.user.accounts.find_each do |account|
        account.update_balance(start_date: last_calc_date)
      end

      Rails.cache.write("last_balance_calculation_date/#{Current.user.id}", Date.current)
    end
  end
end
