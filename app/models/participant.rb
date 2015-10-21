class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  after_update :create_comment
  before_create :set_priority

  private

  def create_comment
    return unless progression_changed?
    task = Task.find(task_id)
    user = User.find(user_id)
    task.comments.create(user_name: user.name, comment: "#{user.name} updated his progress from <span class = 'text-success'>#{progression_was}</span> to <span class = 'text-success'>#{progression}</span>", commenter: user.id)
  end

  def set_priority
    participations = Participant.order('priority ASC').where(user_id: user_id.to_i)
    if participations.count > 0
      last_priority = participations.last.priority.to_i
      self.priority = last_priority + 1
    else
      self.priority = 1
    end
  end
end
