class Task < ActiveRecord::Base
  has_many :participants,  dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :users, through: :participants
  validates :title, presence: true, length: { minimum: 5 }
end
