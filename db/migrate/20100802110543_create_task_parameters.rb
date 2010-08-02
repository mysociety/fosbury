class CreateTaskParameters < ActiveRecord::Migration
  def self.up
    create_table :task_parameters do |t|
      t.string :name
      t.boolean :required
      t.text :description
      t.integer :task_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :task_parameters
  end
end
