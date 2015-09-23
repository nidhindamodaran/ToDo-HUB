class ParticipantsController < ApplicationController
  respond_to :html, :js
  def create
    @participant = Participant.create(participant_params)
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
