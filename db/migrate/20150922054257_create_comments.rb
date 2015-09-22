class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :commenter
      t.text :comment
      t.references :task, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
