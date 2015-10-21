class ParticipantsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json
  autocomplete :user, :name, extra_data: [:email]

  def create
    if params[:user_list].present?
      users_list = params[:user_list].split(',')
      users_list.each do |user_id|
        next if user_id.to_i == 0
        participant = Participant.new(participant_params)
        participant.user_id = user_id.to_i
        participant.save
      end
      redirect_to task_path(params[:task_id]), notice: 'Request sent successfully'
    else
      redirect_to task_path(params[:task_id]), notice: 'Saved changes'
    end
  end

  def accept_request
    @participant = current_user.participants.find(params[:id])
    @participant.update_attributes(status: 'confirmed')
  end

  def set_progression
    @participant = current_user.participants.find_by_task_id(params[:id])
    @participant.update_attributes(progression: params[:progress].to_i)
    @task = @participant.task
  end

  def destroy
    @participant = Participant.find(params[:id])
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
