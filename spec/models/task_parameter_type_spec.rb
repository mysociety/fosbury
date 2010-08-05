# == Schema Information
# Schema version: 20100803101541
#
# Table name: task_parameter_types
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  required     :boolean
#  description  :text
#  task_type_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe TaskParameterType do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :required => false,
      :description => "value for description",
      :task_type_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    TaskParameterType.create!(@valid_attributes)
  end
end

