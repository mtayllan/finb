class Dev::LoginController < ApplicationController
  skip_before_action :authenticate
  skip_before_action :recalculate_balances
  before_action :ensure_development

  def create
    user = User.find(params[:id])
    user_session = Session.create!(user: user)
    cookies.signed[:session_token] = {value: user_session.token, httponly: true, expires: 1.week.from_now}
    redirect_to root_path
  end

  private

  def ensure_development
    raise ActionController::RoutingError, "Not Found" if Rails.env.production?
  end
end
