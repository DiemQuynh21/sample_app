class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      check_user_activation user
    else
      flash.now[:danger] = t "user_login.invalid_user"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
