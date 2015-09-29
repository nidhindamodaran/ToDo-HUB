class ParticipantsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  def create
    @users_list = params[:check_user]
    @users_list.each do |user_id|
      participations = Participant.where(user_id:user_id.to_i)
      if participations.count > 0
        last_priority = participations.last.priority.to_i
        priority = last_priority + 1
        @participant = Participant.new(participant_params)
        @participant.priority = priority
        @participant.user_id = user_id.to_i
        @participant.save
      else
        @participant = Participant.new(participant_params)
        @participant.priority = 1
        @participant.user_id = user_id.to_i
        @participant.save
      end
    end
    redirect_to task_path(params[:task_id])
  end

  def accept_request
    @participant = Participant.find(params[:id])
    @participant.status = 'confirmed'
    @participant.save
  end
  def set_progression
    @participant = Participant.find_by_task_id_and_user_id(params[:id],current_user.id)
    @participant.progression = params[:progress].to_i
    @participant.save
  end
  def destroy
    @participant = Participant.find(params[:id])
    @participant.destroy
  end

  private

  def participant_params
    params.permit(:task_id, :status)
  end
end
