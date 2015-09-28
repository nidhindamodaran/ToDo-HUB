class AddColoumnDefualtToTasks < ActiveRecord::Migration
  def change
    change_column_default :tasks, :status, 0
  end
end
