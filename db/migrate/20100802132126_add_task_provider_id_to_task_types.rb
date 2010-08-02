class AddTaskProviderIdToTaskTypes < ActiveRecord::Migration
  def self.up
    add_column :task_types, :task_provider_id, :integer
  end

  def self.down
    remove_column :task_types, :task_provider_id
  end
end
