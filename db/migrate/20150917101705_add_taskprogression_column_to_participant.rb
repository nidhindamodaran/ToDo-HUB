class AddTaskprogressionColumnToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :progression, :integer
  end
end
