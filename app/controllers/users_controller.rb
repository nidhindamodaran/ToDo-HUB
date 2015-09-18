class UsersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  def index
    @tasks = Task.where(user_id: current_user.id, completed: false)
  end
end
