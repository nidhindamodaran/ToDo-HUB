class TasksController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  def index
    @task = Task.new
    @tasks = Task.joins(:participants).order('participants.priority asc').where(participants:{status:'confirmed',user_id:current_user.id},completed:false)
    #@tasks = Task.where(user_id: current_user.id, completed: false)
  end
  def create
   @tasks = Task.joins(:participants).order('participants.priority asc').where(participants:{status:'confirmed',user_id:current_user.id},completed:false)
   @task = current_user.tasks.new(task_params)
   @task.user_id = current_user.id
   @task.save
   participations = Participant.where(user_id:current_user.id)
   #p "#{participations.count} .........................................................asdfffffffffffffffffffffffff"
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
    @task = Task.find(params[:id])
    @task.destroy
  end

  def confirm_delete
    @task = Task.find(params[:id])
    @participant = Participant.find_by_task_id(params[:id])
    render 'confirm_delete'
  end
  def show
    @users = User.all
    @task = Task.find(params[:id])
    @creator = User.find(@task.user_id)
    @participant = Participant.find_by_task_id_and_user_id(params[:id],current_user.id)
    @participants = Participant.where(task_id:params[:id])
    @total_completion = Participant.find_total_progression(params[:id])
  end

  def active_tasks
    @tasks = Task.joins(:participants).order('participants.priority asc').where(participants:{status:'confirmed',user_id:current_user.id},completed:false)
  end
  def completed_tasks
    @tasks = Task.joins(:participants).order('participants.priority asc').where(participants:{status:'confirmed',user_id:current_user.id},completed:true)
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

  def task_up
     @participant = Participant.find_by_task_id_and_user_id(params[:id],current_user.id)
     priority = @participant.priority
     @other_participant = current_user.participants.where("priority < ?",priority).last
     other_priority = @other_participant.priority
     @participant.priority, @other_participant.priority = @other_participant.priority, @participant.priority
     @participant.save!
     @other_participant.save!
  end

  def task_down
    @participant = Participant.find_by_task_id_and_user_id(params[:id],current_user.id)
    priority = @participant.priority
    @other_participant = current_user.participants.where("priority > ?",priority).first
    other_priority = @other_participant.priority
    @participant.priority, @other_participant.priority = @other_participant.priority, @participant.priority
    @participant.save!
    @other_participant.save!
  end


  private
  def task_params
    params.require(:task).permit(:title, :description)
  end

end
