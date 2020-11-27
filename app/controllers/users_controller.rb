class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :load_user, except: [:index, :new, :create]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: Settings.user.page.per_page
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t "home_title"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "edit_user.update_success"
      redirect_to @user
    else
      flash.now[:danger] = t "edit_user.update_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "delete_user.mess_success"
    else
      flash[:danger] = t "delete_user.mess_fail"
    end
    redirect_to users_url
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "edit_user.mess_logged"
    redirect_to login_path
  end

  def load_user
    return if @user = User.find_by(id: params[:id])

    flash[:danger] = t "show_user.user_not_found"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end
end
