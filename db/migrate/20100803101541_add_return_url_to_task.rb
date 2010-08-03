class AddReturnUrlToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :return_url, :text
  end

  def self.down
    remove_column :tasks, :return_url
  end
end
