class Comment < ActiveRecord::Base
  belongs_to :task
  validates :comment, presence: true, length: { minimum: 1 }
end
