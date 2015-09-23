class TasksController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  def index
    @task = Task.new
    @tasks = current_user.tasks.where(completed:false)
    #@tasks = Task.where(user_id: current_user.id, completed: false)
  end
  def create
   @task = current_user.tasks.new(task_params)
   @task.user_id = current_user.id
   @task.save
   @participant = Participant.new(user_id:current_user.id, task_id:@task.id, status:'confirmed')
   @participant.save
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
    @users = User.all
    @task = Task.find(params[:id])
  end

  def active_tasks
    @tasks = current_user.tasks.where(completed:false)
  end
  def completed_tasks
    @tasks = Task.where(completed: true)
  end

  def task_requests
    @participants  = Participant.where(status: "pending", user_id:current_user.id)
    @tasks = Task.all
  end

  def task_completion
    @task = Task.find(params[:id])
    if @task.completed == false
      @task.completed = true
      @task.comments.create(user_name: current_user.name, comment:'Status changed to Done')
    else
      @task.completed = false
      @task.comments.create(user_name: current_user.name, comment:'Status changed to UnDone')
    end
    if @task.save
      respond_with(@task) do |format|
        format.html{redirect_to task_path(params[:id])}
      end
    else
      render plain: "Error"
    end

  end

  def add_participants
    @users = User.all
    @participant = Participant.new
    @task = Task.find(params[:id])
  end


  private
  def task_params
    params.require(:task).permit(:title, :description)
  end

end
