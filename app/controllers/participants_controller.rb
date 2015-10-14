class ParticipantsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js

  def create
    if params[:check_user].present?
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

      redirect_to task_path(params[:task_id]), notice: "Request sent successfully"
    else
      redirect_to task_path(params[:task_id]), notice: "Select atleast one"

    end
  end

  def accept_request
    @participant = current_user.participants.find(params[:id])
    @participant.status = 'confirmed'
    @participant.save
  end

  def set_progression
    @participant = current_user.participants.find_by_task_id(params[:id])
    @participant.update_attributes(progression:params[:progress].to_i)
  end

  def destroy
    @participant = current_user.participants.find(params[:id])
    @participant.destroy
    if @participant.task.completed == true
      @tasks = Task.completed(current_user).paginate(page: params[:page], per_page: 10)
    else
      @tasks = Task.active(current_user).paginate(page: params[:page], per_page: 10)
    end
  end

  private

  def participant_params
    params.permit(:task_id, :status)
  end
end
