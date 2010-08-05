class AddDataToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :task_data, :text
  end

  def self.down
    remove_column :tasks, :task_data
  end
end
