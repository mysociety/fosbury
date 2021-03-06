# == Schema Information
# Schema version: 20100803101541
#
# Table name: tasks
#
#  id              :integer         not null, primary key
#  task_type_id    :integer
#  created_at      :datetime
#  updated_at      :datetime
#  callback_url    :string(255)
#  callback_params :text
#  status_code     :integer         default(0)
#  return_url      :text
#

require 'spec_helper'

describe Task do
  before(:each) do
    @valid_attributes = {
      :task_type_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Task.create!(@valid_attributes)
  end
  
  describe 'when accepting a status update' do 
  
    it "should update its status code" do 
      task = Task.new( :status_code => 0 )
      task.status = :complete
      task.status_code.should == 2
    end
    
  end
  
  describe 'when asked for its status' do 
  
    it 'should return the correct symbol for its status code' do 
      task = Task.new( :status_code => 0 )
      task.status.should == :new
      task.status_code = 1
      task.status.should == :in_progress
    end
  end
  
  describe 'when asked for its status description' do 
  
    it 'should return the correct description for its status code' do 
      task = Task.new( :status_code => 0 )
      task.status_description.should == 'New'
      task.status_code = 1
      task.status_description.should == 'In Progress'
    end
    
  end
  
  describe "when creating a start url" do 
    
    it "should return '' if there is no start url for its task type" do 
      @task_type = mock_model(TaskType, :start_url => nil)
      task = Task.new(:task_type => @task_type)
      task.start_url.should == ''
    end
    
  end
  
end
