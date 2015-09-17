class UsersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  def index
    @tasks = current_user.tasks.reverse
  end
end
