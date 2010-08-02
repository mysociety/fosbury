class CreateTaskProviders < ActiveRecord::Migration
  def self.up
    create_table :task_providers do |t|
      t.string :name
      t.string :api_key

      t.timestamps
    end
  end

  def self.down
    drop_table :task_providers
  end
end
