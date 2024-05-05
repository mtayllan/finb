class SessionsController < ActionController::Base
  layout false

  before_action :check_feature_enabled

  Credentials = Data.define(:username, :password)

  def show
    @credentials = Credentials.new(username: "", password: "")
  end

  def create
    username, password = ENV.fetch("CREDENTIAL").split(":")

    credentials_params = params.permit(:username, :password)
    @credentials = Credentials.new(credentials_params[:username], credentials_params[:password])

    if @credentials.username == username && @credentials.password == password
      cookies.signed[:authenticated] = { value: true, expires: 1.week.from_now }
      redirect_to root_url
    else
      flash.now[:alert] = "Invalid username or password."
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    cookies.delete(:authenticated)
    redirect_to sessions_url
  end

  private

  def check_feature_enabled
    return if ENV.fetch("CREDENTIAL", "").split(":").size == 2

    redirect_to root_url
  end
end
