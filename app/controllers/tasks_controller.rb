class TasksController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  def index
    @task = Task.new
    @tasks = Task.where(user_id: current_user.id, completed: false)
  end
  def create
   @task = Task.new(task_params)
   @task.user_id = current_user.id
   @task.save
    redirect_to tasks_path
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
  end

  def confirm_delete
    @id = params[:id]
    render 'confirm_delete'
  end
  def show
    @task = Task.find(params[:id])
  end

  def active_tasks
    @tasks = Task.where(completed: false, user_id: current_user.id)
  end
  def completed_tasks
    @tasks = Task.where(completed: true)
  end

  def task_requests
  end

  def task_completion
    @task = Task.find(params[:id])
    if @task.completed == false
      @task.completed = true
    else
      @task.completed = false
    end
    if @task.save
      puts "error #{@task.inspect}"
    else
      render plain: "Error"
    end
  end


  private
  def task_params
    params.require(:task).permit(:title, :description)
  end

end
