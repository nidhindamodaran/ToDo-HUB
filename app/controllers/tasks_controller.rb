class TasksController < ApplicationController
  def create
   current_user.tasks.create(task_params)
    redirect_to users_path
  end
  private
  def task_params
    params.require(:task).permit(:title, :description)
  end
end
