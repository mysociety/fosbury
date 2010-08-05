class AddParamsToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :params, :text
  end

  def self.down
    remove_column :tasks, :params
  end
end
