class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  def self.find_total_progression(task_id)
    participants = Participant.where(task_id:task_id)
    total = 0;
    count = participants.count
    participants.each do |participant|
      total += participant.progression
    end
    avg_progression = total/count
  end

  def self.swap(first, second)
    first.priority, second.priority = second.priority, first.priority
    first.save!
    second.save!
  end
end
