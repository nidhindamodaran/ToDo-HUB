class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user, :except => :index
  respond_to :html, :js

  def index
    @users = User.all
  end
  def show
    @tasks = Task.where(user_id:params[:id])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user, flash: { notice:"Updated succesfully" }
    else
      redirect_to @user, flash: { notice:"Updation not success" }
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name,:avatar,:about)
  end

end
