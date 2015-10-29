class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user, except: :index
  respond_to :html, :js

  def index
    @users = User.all
  end

  def show
    if current_user == @user
      flash.now[:notice] = 'Your profile is not complete ! Complete now' unless @user.avatar_file_size.present?
    end
    @tasks = Task.where(user_id: params[:id])
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user, notice: 'Saved succesfully'
    else
      redirect_to @user, notice: 'Saving not success'
    end
  end

  def destroy
    current_user.destroy
    redirect_to root_path
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :avatar, :about)
  end
end
