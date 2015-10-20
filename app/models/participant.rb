class Participant < ActiveRecord::Base

  belongs_to :user
  belongs_to :task

  after_update :create_comment
  private

  def create_comment
    if self.progression_changed?
      task = Task.find(self.task_id)
      user = User.find(self.user_id)
      task.comments.create(user_name: user.name, comment:"#{user.name} updated his progress from <span class = 'text-success'>#{self.progression_was}</span> to <span class = 'text-success'>#{self.progression}</span>", commenter:user.id)
    end
  end
end
