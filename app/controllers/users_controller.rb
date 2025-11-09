class UsersController < ApplicationController
  before_action :require_superuser
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.order(:username)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: "User created successfully"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "User updated successfully"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @user == Current.user
      redirect_to users_path, alert: "Cannot delete your own user account"
      return
    end

    @user.destroy
    redirect_to users_path, notice: "User deleted successfully"
  end

  private

  def require_superuser
    unless Current.user&.superuser?
      redirect_to root_path, alert: "Access denied. Superuser privileges required."
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :superuser)
  end
end
