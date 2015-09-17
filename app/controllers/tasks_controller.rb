class TasksController < ApplicationController
  respond_to :html, :js
  def create
   current_user.tasks.create(task_params)
    redirect_to users_path
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to users_path
  end

  def confirm_delete
    @id = params[:id]
    render 'confirm_delete'
  end
  def show
  end
  private
  def task_params
    params.require(:task).permit(:title, :description)
  end
end
