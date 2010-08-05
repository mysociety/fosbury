class RenameTaskParameterToTaskParameterType < ActiveRecord::Migration
  def self.up
    rename_table :task_parameters, :task_parameter_types
  end

  def self.down
    rename_table :task_parameter_types, :task_parameters
  end
end
