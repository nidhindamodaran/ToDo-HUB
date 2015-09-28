class AddColumnDefaultToParticipants < ActiveRecord::Migration
  def change
    change_column_default :participants, :progression, 0
  end
end
