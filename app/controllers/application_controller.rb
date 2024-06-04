class ApplicationController < ActionController::Base
  before_action :authenticate

  def authenticate
    return if ENV.fetch("CREDENTIAL", "").split(":").size != 2
    redirect_to sessions_url unless Session.exists?(token: cookies.signed[:auth_token])
  end
end
