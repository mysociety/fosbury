class AddDescriptionToTaskTypes < ActiveRecord::Migration
  def self.up
    add_column :task_types, :description, :text
  end

  def self.down
    remove_column :task_types, :description
  end
end
