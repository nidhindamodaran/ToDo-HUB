class UsersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  def index
    @users = User.all
  end

end
