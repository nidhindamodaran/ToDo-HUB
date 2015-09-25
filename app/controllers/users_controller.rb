class UsersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  def index
    @users = User.all
  end
  def show
    @user    = User.find(params[:id])
    puts @user
    @tasks = Task.where(user_id:params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
      redirect_to @user
  end

  private

  def user_params
    params.require(:user).permit(:name,:avatar,:about)
  end

end
