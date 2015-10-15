class AddIndexToParticipants < ActiveRecord::Migration
  def change
    add_index :participants, :user_id
    add_index :participants, :task_id
  end
end
