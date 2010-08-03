class AddStatusCodeToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :status_code, :integer, :default => 0
  end

  def self.down
    remove_column :tasks, :status_code
  end
end
