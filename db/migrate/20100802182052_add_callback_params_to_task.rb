class AddCallbackParamsToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :callback_params, :text
  end

  def self.down
    remove_column :tasks, :callback_params
  end
end
