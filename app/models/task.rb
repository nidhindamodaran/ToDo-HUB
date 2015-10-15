class Task < ActiveRecord::Base
   scope :completed, ->(user) {
     includes(:participants).
     order('participants.priority desc').
     where(participants:{status:'confirmed',user_id:user.id},completed:true)
    }

    scope :active, ->(user) {
      includes(:participants).
      order('participants.priority desc').
      where(participants:{status:'confirmed',user_id:user.id},completed:false)
     }

  has_many :participants,  dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :users, through: :participants
  validates :title, presence: true, length: { minimum: 1 }

  after_create :participant_create
  after_update :toggle_status

  def swap_tasks(user,action)
    participant = user.participants.find_by_task_id(self.id)
    priority = participant.priority
    if action == "task_up"
      if self.completed == true
        other_participant = user.participants.joins(:task).
                            where("participants.priority > ? AND tasks.completed = ?",priority, true).
                            order('priority DESC').last
      else
        other_participant = user.participants.joins(:task).
                            where("participants.priority > ? AND tasks.completed = ?",priority, false).
                            order('priority DESC').last
      end
    else
      if self.completed == true
       other_participant =  user.participants.joins(:task).
                             where("participants.priority < ? AND tasks.completed = ?",priority, true).
                             order('priority DESC').first
     else
       other_participant =  user.participants.joins(:task).
                            where("participants.priority < ? AND tasks.completed = ?",priority, false).
                            order('priority DESC').first
     end
    end
    swap_priority(participant, other_participant)

    [participant, other_participant]
  end


  private

  #-- creating participant entry for task author and marking  status as confirmed
  def participant_create
    participations = Participant.where(user_id:self.user_id)
    if participations.count > 0
      last_priority = participations.last.priority.to_i
      priority = last_priority + 1
      Participant.create(user_id:self.user_id, task_id:self.id, status:'confirmed', priority:priority)
    else
      Participant.create(user_id:self.user_id, task_id:self.id, status:'confirmed', priority:1)
    end
  end
#--- Toggling task status to completed or not completed ---#
  def toggle_status
    if self.completed_changed?
      user = User.find(self.user_id)
      if self.completed == true
        self.comments.create(user_name: user.name, comment:'Status changed to <span class = "text-success">Done</span>',commenter:user.id)
      else
        self.comments.create(user_name: user.name, comment:'Status changed to <span class = "text-danger">UnDone</span>',commenter:user.id)
      end
    end
  end
#--swaps priority of two participants ---#
  def swap_priority(first, second)
    first.priority, second.priority = second.priority, first.priority
    first.save!
    second.save!
  end

end
