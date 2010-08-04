class AddSetterIdToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :setter_id, :integer
  end

  def self.down
    remove_column :tasks, :setter_id
  end
end
