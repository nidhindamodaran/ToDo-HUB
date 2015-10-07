module TasksHelper
  def total_completion(task)
    Participant.find_total_progression(task.id).to_i
  end

  def creator(task)
    User.find(task.user_id)
  end
end
