class ParticipantsController < ApplicationController
  respond_to :html, :js
  def create
    participations = Participant.where(user_id:params[:user_id])
    if participations.count > 0
      last_priority = participations.last.priority.to_i
      priority = last_priority + 1
      @participant = Participant.new(participant_params)
      @participant.priority = priority
    else
      @participant = Participant.new(participant_params)
      @participant.priority = 1
    end
      if @participant.save
        flash[:notice]="Request sent successfully"
      end
  end
  def accept_request
    @participant = Participant.find(params[:id])
    @participant.status = 'confirmed'
    @participant.save
  end
  def destroy
    @participant = Participant.find(params[:id])
    @participant.destroy
  end

  private

  def participant_params
    params.permit(:user_id, :task_id, :status)
  end
end
