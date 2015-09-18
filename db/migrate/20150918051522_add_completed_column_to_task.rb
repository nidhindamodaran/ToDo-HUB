class AddCompletedColumnToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :completed, :boolean,  :default => false
  end
end
