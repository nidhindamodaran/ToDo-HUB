class ChangeComments < ActiveRecord::Migration
  def change
    remove_column :comments, :user_id
    add_column :comments, :user_name, :string
  end
end
