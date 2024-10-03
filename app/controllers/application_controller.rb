class ApplicationController < ActionController::Base
  before_action :authenticate

  def authenticate
    if (user_session = Session.find_by(token: cookies.signed[:session_token]))
      Current.user = user_session.user
    else
      session[:return_to_after_authenticating] = request.url
      redirect_to new_sessions_path, alert: "Please sign in"
    end
  end
end
