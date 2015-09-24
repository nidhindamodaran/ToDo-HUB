class UsersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  def index
    @users = User.all
  end
  def show
    @user = User.find(params[:id])
    @tasks = Task.where(user_id:params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end


end
