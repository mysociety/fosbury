require 'spec_helper'

describe TasksController do

  describe 'responding to POST #create' do 

    before do 
      TaskType.stub!(:find).and_return(mock_model(TaskType, :callback_url => 'http://www.example.com/callback'))
    end
    
    def make_request data
      post :create, data
    end
    
    def default_task_attrs
     { :task => { :task_type_id => "a-test-task" } }
    end
    
    it 'should redirect to the task type callback URL' do
      make_request(default_task_attrs)
      @response.should redirect_to('http://www.example.com/callback')
      @response.status.should == "302 Found"
    end
    
    it 'should create a new task associated with the correct task type' do 
      Task.should_receive(:create).with( 'task_type_id' => "a-test-task" )
      make_request( default_task_attrs )
    end
  
    it 'should return an error message and a bad request status code if no task type id is given' do 
      task_attrs = default_task_attrs
      task_attrs[:task].delete(:task_type_id)
      make_request( task_attrs )
      @response.status.should == "400 Bad Request"
    end
    
    it 'should return an error message and a bad request status code if the task type cannot be found' do 
      TaskType.stub!(:find).and_return(nil)
      make_request( default_task_attrs )
      @response.status.should == "400 Bad Request"
    end
    
  end

end