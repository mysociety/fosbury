class AddCallbackUrlToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :callback_url, :string
  end

  def self.down
    remove_column :tasks, :callback_url
  end
end
