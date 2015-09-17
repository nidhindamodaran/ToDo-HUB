class AddColumnToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :priority, :integer
    add_column :participants, :status, :string, :default => "pending"
  end
end
