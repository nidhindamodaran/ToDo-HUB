class TasksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_task, except: [:index, :create, :active_tasks, :completed_tasks, :task_requests]
  respond_to :html, :js

  def index
    @task = Task.new
    @tasks = Task.active(current_user).paginate(page: params[:page], per_page: 10)
  end

  def show
    @users = User.all
    @participant = current_user.participants.find_by_task_id(params[:id])
  end

  def edit
  end

  def create
   @task = current_user.tasks.new(task_params)
   @task.user_id = current_user.id
   @save_flag = @task.save
     #flash.now[:notice] = "Task creation Successfull"
   #else
     #redirect_to tasks_path, notice:"Task creation Unsuccessfull"
     #flash.now[:notice] = "Task creation Unsuccessfull"

  end

  def update
    if @task.update_attributes(task_params)
      redirect_to task_path(@task.id), notice:"Task updated Successfully"
    else
      redirect_to task_path(@task.id), notice:"Task updation Failed"
    end
  end

  def destroy
    @task.destroy
    respond_with(@task) do |format|
      format.html{redirect_to tasks_path}
    end
  end

  def confirm_delete
    @participant = current_user.participants.find_by_task_id(@task.id)
  end

  def active_tasks
    @tasks = Task.active(current_user).paginate(page: params[:page], per_page: 10)
  end

  def completed_tasks
    @tasks = Task.completed(current_user).paginate(page: params[:page], per_page: 10)
  end

  def task_requests
    @participants  = Participant.where(status: "pending", user_id:current_user.id)
    @tasks = Task.all
  end

  def task_completion
    if @task.update_attributes(completed:params[:status])
      respond_with(@task) do |format|
        format.html{redirect_to task_path(params[:id])}
      end
    else
      redirect_to task_path @task, flash: { error:"Task completion error" }
    end

  end

  def add_participants
    @users = User.all
    @participant = Participant.new
  end

  def task_up
    @participant, @other_participant = @task.swap_tasks(current_user,"task_up")
  end

  def task_down
    @participant, @other_participant = @task.swap_tasks(current_user,"task_down")
  end


  private

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description)
  end


end
