class Task < ActiveRecord::Base
  has_many :participants
  has_many :comments
  has_many :users, through: :participants
  validates :title, presence: true, length: { minimum: 5 }
end
