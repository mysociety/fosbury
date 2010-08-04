class RenameTaskProviderToApplication < ActiveRecord::Migration
  def self.up
    rename_table :task_providers, :applications
  end

  def self.down
    rename_table :applications, :task_providers
  end
end
