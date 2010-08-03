# == Schema Information
#
# Table name: task_types
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  cached_slug  :string(255)
#  start_url :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class TaskType < ActiveRecord::Base
  has_friendly_id :name, :use_slug => true
  has_many :parameters, :class_name => 'TaskParameter'
  has_many :tasks
  accepts_nested_attributes_for :parameters

end

