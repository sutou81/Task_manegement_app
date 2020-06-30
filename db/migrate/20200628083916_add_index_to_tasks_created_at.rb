class AddIndexToTasksCreatedAt < ActiveRecord::Migration[5.1]
  def change
  end
    add_index :tasks, :created_at
end
