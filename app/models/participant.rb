class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  default_scope  { order(priority: :asc) }
end
