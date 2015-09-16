class AddColumnsToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :user_id, :integer
    add_column :participants, :task_id, :integer
  end
end
