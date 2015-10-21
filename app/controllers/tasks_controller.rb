class TasksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_task, except: [:index, :edit, :create, :active_tasks, :completed_tasks, :task_requests, :remove_share]
  before_filter :find_task_list, only: [:task_completion, :destroy, :task_up, :task_down]
  before_filter :find_active_tasks, only: [:index, :create]
  respond_to :html, :js, :json

  def index
    @task = Task.new
  end

  def show
    @users = User.all
    @participant = current_user.participants.find_by_task_id(params[:id])
    @comments = @task.comments.paginate(page: params[:page], per_page: 10)
  end

  def create
    @task = current_user.tasks.new(task_params)
    @task.user_id = current_user.id
    @save_flag = @task.save
  end

  def update
    if @task.update_attributes(task_params)
      redirect_to task_path(@task.id), notice: 'Task updated Successfully'
    else
      redirect_to task_path(@task.id), notice: 'Task updation Failed'
    end
  end

  def destroy
    @task.destroy
    respond_with(@task) do |format|
      format.html { redirect_to tasks_path }
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
    @participants  = Participant.where(status: 'pending', user_id: current_user.id)
    @tasks = Task.all
  end

  def task_completion
    if @task.update_attributes(completed: params[:status])
      respond_with(@task) do |format|
        format.html { redirect_to task_path(params[:id]) }
      end
    else
      redirect_to task_path @task, flash: { error: 'Task completion error' }
    end
  end

  def add_participants
    @users = User.all
    @participant = Participant.new
    @participants = Participant.where(task_id: @task.id)
  end

  def task_up
    @task.swap_tasks(current_user, 'task_up')
  end

  def task_down
    @task.swap_tasks(current_user, 'task_down')
  end

  def remove_share
    task = Task.find(params[:task_id])
    participant = task.participants.find_by_user_id(params[:user_id])
    participant.destroy
  end

  private

  def find_task
    @task = Task.find(params[:id])
  end

  def find_task_list
    if @task.completed == true
      @tasks = Task.completed(current_user).paginate(page: params[:page], per_page: 10)
    else
      @tasks = Task.active(current_user).paginate(page: params[:page], per_page: 10)
    end
  end

  def find_active_tasks
    @tasks = Task.active(current_user).paginate(page: params[:page], per_page: 10)
  end

  def task_params
    params.require(:task).permit(:title, :description)
  end
end
