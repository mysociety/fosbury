class RenameTaskTypeCallbackUrl < ActiveRecord::Migration
  def self.up
    rename_column :task_types, :callback_url, :start_url
  end

  def self.down
    rename_column :task_types, :start_url, :callback_url
  end
end
