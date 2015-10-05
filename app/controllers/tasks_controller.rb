class TasksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_task, :only => [:destroy,:confirm_delete, :show, :task_completion, :add_participants, :edit, :update]
  respond_to :html, :js

  def index
    @task = Task.new
    @tasks = Task.joins(:participants).
                  order('participants.priority asc').
                  where(participants:{status:'confirmed',user_id:current_user.id},completed:false).
                  paginate(:page => params[:page], :per_page => 5)
  end


  def create
   @tasks = Task.joins(:participants).
                 order('participants.priority asc').
                 where(participants:{status:'confirmed',user_id:current_user.id},completed:false)
   @task = current_user.tasks.new(task_params)
   @task.user_id = current_user.id
   @task.save
   #-- creating participant entry for task author
   participations = Participant.where(user_id:current_user.id)
   if participations.count > 0
     last_priority = participations.last.priority.to_i
     priority = last_priority + 1
     @participant = Participant.new(user_id:current_user.id, task_id:@task.id, status:'confirmed', priority:priority)
   else
     @participant = Participant.new(user_id:current_user.id, task_id:@task.id, status:'confirmed', priority:1)
   end
     @participant.save
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
  def show
    @users = User.all
    @creator = User.find(@task.user_id)
    @participant = Participant.find_by_task_id_and_user_id(params[:id],current_user.id)
    @participants = Participant.where(task_id:params[:id])
    @total_completion = Participant.find_total_progression(params[:id])
  end

  def active_tasks
    @tasks = Task.joins(:participants).
                  order('participants.priority asc').
                  where(participants:{status:'confirmed',user_id:current_user.id},completed:false).
                  paginate(:page => params[:page], :per_page => 5)
  end
  def completed_tasks
    @tasks = Task.joins(:participants).
                  order('participants.priority asc').
                  where(participants:{status:'confirmed',user_id:current_user.id},completed:true).
                  paginate(:page => params[:page], :per_page => 5)
  end

  def task_requests
    @participants  = Participant.where(status: "pending", user_id:current_user.id).paginate(:page => params[:page], :per_page => 10)
    @tasks = Task.all
  end

  def task_completion
    if @task.completed == false
      @task.completed = true
      @task.comments.create(user_name: current_user.name, comment:'Status changed to Done')
    else
      @task.completed = false
      @task.comments.create(user_name: current_user.name, comment:'Status changed to UnDone',commenter:current_user.id)
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
  end

  def task_up
     @participant = current_user.participants.find_by_task_id(params[:id])
     priority = @participant.priority
     @other_participant = current_user.participants.where("priority < ?",priority).last
     other_priority = @other_participant.priority
     ## swaps priority of two participants
     @participant.priority, @other_participant.priority = @other_participant.priority, @participant.priority
     @participant.save!
     @other_participant.save!
  end

  def task_down
    @participant = current_user.participants.find_by_task_id(params[:id])
    priority = @participant.priority
    @other_participant = current_user.participants.where("priority > ?",priority).first
    other_priority = @other_participant.priority
    @participant.priority, @other_participant.priority = @other_participant.priority, @participant.priority
    @participant.save!
    @other_participant.save!
  end

  def edit
  end

  def update
    @task.update_attributes(task_params)
    redirect_to task_path(@task.id)
  end


  private

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description)
  end

end
