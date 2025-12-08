class SetupsController < ApplicationController
  layout false
  skip_before_action :authenticate

  before_action :redirect_if_users_exist

  def show
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.superuser = true

    if @user.save
      session = Session.create(user: @user)
      cookies.signed[:session_token] = {value: session.token, httponly: true, expires: 1.week.from_now}

      redirect_to root_path, notice: "Welcome! Your account has been created successfully"
    else
      render :show, status: :unprocessable_content
    end
  end

  private

  def redirect_if_users_exist
    redirect_to new_sessions_path if User.exists?
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
