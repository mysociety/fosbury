# == Schema Information
# Schema version: 20100803101541
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

class TaskParameterType < ActiveRecord::Base
  belongs_to :task_type
end

