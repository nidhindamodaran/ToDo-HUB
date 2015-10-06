class ParticipantsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js

  def create
    @users_list = params[:check_user]
    @users_list.each do |user_id|
      participations = Participant.where(user_id:user_id.to_i)
      @participant = Participant.new(participant_params)
      if participations.count > 0
        last_priority = participations.last.priority.to_i
        priority = last_priority + 1
        @participant.priority = priority
      else
        @participant.priority = 1
      end
      @participant.user_id = user_id.to_i
      @participant.save
    end
    redirect_to task_path(params[:task_id])
  end

  def accept_request
    @participant = current_user.participants.find(params[:id])
    @participant.status = 'confirmed'
    @participant.save
  end

  def set_progression
    @participant = current_user.participants.find_by_task_id(params[:id])
    old_progress = @participant.progression
    @participant.progression = params[:progress].to_i
    if @participant.save
      @task = Task.find(params[:id])
      @task.comments.create(user_name: current_user.name, comment:"#{current_user.name} updated his progress from #{old_progress} to #{params[:progress]}", commenter:current_user.id)
    end
    @total_completion = Participant.find_total_progression(params[:id])
  end
  
  def destroy
    @participant = current_user.participants.find(params[:id])
    @participant.destroy
  end

  private

  def participant_params
    params.permit(:task_id, :status)
  end
end
