class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :task_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
