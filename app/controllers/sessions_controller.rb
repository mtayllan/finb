class SessionsController < ApplicationController
  layout false
  skip_before_action :authenticate

  def new
    redirect_to post_authentication_url if Session.find_by(token: cookies.signed[:session_token])
  end

  def create
    if (user = User.authenticate_by(username: params[:username], password: params[:password]))
      session = Session.create(user: user)
      cookies.signed[:session_token] = {value: session.token, httponly: true, expires: 1.week.from_now}

      redirect_to post_authentication_url, notice: "Signed in successfully"
    else
      flash.now[:alert] = "Invalid credentials"
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    cookies.delete(:session_token)
    redirect_to new_sessions_url, notice: "Signed out successfully"
  end

  def post_authentication_url
    session.delete(:return_to_after_authenticating) || root_path
  end
end
