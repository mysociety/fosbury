class RenameTaskProviderIdToProviderId < ActiveRecord::Migration
  def self.up
    rename_column :task_types, :task_provider_id, :provider_id
  end

  def self.down
    rename_column :task_types, :provider_id, :task_provider_id
  end
end
