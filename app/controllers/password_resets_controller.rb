class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email]

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "reset_password.checkmail_resetpw"
      redirect_to root_path
    else
      flash[:danger] = t "reset_password.not_found_email"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("reset_password.pass_empty"))
      render :edit
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = t "reset_password.reset_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit; end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    return if @user = User.find_by(email: params[:email])

    flash[:danger] = t "account.not_find_account"
    redirect_to root_path
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "show_user.user_not_found"
    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "reset_password.pass_expire"
    redirect_to new_password_reset_url
  end
end
