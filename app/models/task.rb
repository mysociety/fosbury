class Task < ActiveRecord::Base
  belongs_to :task_type
  belongs_to :task_provider
  validates_presence_of :task_type_id
end
