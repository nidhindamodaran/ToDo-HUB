class Task < ActiveRecord::Base
  scope :completed, lambda { |user|
    includes(:participants)
    .order('participants.priority desc')
    .where(participants: { status: 'confirmed', user_id: user.id }, completed: true)
  }
  scope :active, lambda { |user|
    includes(:participants)
    .order('participants.priority desc')
    .where(participants: { status: 'confirmed', user_id: user.id }, completed: false)
  }
  has_many :participants,  dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :users, through: :participants
  accepts_nested_attributes_for :participants, allow_destroy: true
  validates :title, presence: true, length: { minimum: 1 }

  after_create :participant_create
  after_update :toggle_status

  def swap_tasks(user, action)
    participant = user.participants.find_by_task_id(id)
    priority = participant.priority
    if action == 'task_up'
      if completed == true
        other_participant = user.participants.joins(:task)
        .where('participants.priority > ? AND tasks.completed = ?', priority, true)
        .order('priority DESC').last
      else
        other_participant = user.participants.joins(:task)
        .where('participants.priority > ? AND tasks.completed = ?', priority, false)
        .order('priority DESC').last
      end
    else
      if completed == true
        other_participant =  user.participants.joins(:task)
        .where('participants.priority < ? AND tasks.completed = ?', priority, true)
        .order('priority DESC').first
      else
        other_participant =  user.participants.joins(:task)
        .where('participants.priority < ? AND tasks.completed = ?', priority, false)
        .order('priority DESC').first
      end
    end
    swap_priority(participant, other_participant)
  end

  private

  #-- creating participant entry for task author and marking  status as confirmed
  def participant_create
    participations = Participant.order('priority ASC').where(user_id: user_id)
    if participations.count > 0
      last_priority = participations.last.priority.to_i
      priority = last_priority + 1
      Participant.create(user_id: user_id, task_id: id, status: 'confirmed', priority: priority)
    else
      Participant.create(user_id: user_id, task_id: id, status: 'confirmed', priority: 1)
    end
  end
  #--- Toggling task status to completed or not completed ---#
  def toggle_status
    return unless completed_changed?
    user = User.find(user_id)
    if completed == true
      comments.create(user_name: user.name, comment: 'Status changed to <span class = "text-success">Done</span>', commenter: user.id)
    else
      comments.create(user_name: user.name, comment: 'Status changed to <span class = "text-danger">UnDone</span>', commenter: user.id)
    end
  end
  #--swaps priority of two participants ---#
  def swap_priority(first, second)
    first.priority, second.priority = second.priority, first.priority
    first.save!
    second.save!
  end
end