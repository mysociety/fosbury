# == Schema Information
#
# Table name: task_parameters
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  required     :boolean
#  description  :text
#  task_type_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class TaskParameter < ActiveRecord::Base
  belongs_to :task
end

