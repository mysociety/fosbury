require 'spec_helper'

describe TasksController do

  before do 
    controller.stub!(:external_json_request)
  end
  
  describe 'responding to POST #create' do 

    before do 
      TaskType.stub!(:find).and_return(mock_model(TaskType, :start_url => 'http://taskprovider.example.com/start'))
    end
    
    def make_request data
      post :create, data
    end
    
    def default_task_attrs
     { :task => { :task_type_id => "a-test-task" } }
    end
    
    def get_redirect_params
      redirect = response.redirected_to
      CGI.parse(redirect.split("?")[1])
    end
    
    def get_redirect_path
      redirect = response.redirected_to
      redirect.split("?")[0]
    end
    
    it 'should redirect to the task type start URL' do
      make_request(default_task_attrs)
      get_redirect_path.should == 'http://taskprovider.example.com/start'
      response.status.should == "302 Found"
    end
    
    it 'should create a new task associated with the correct task type' do 
      Task.should_receive(:create).with( 'task_type_id' => "a-test-task" )
      make_request( default_task_attrs )
    end
  
    it 'should return an error message and a bad request status code if no task type id is given' do 
      task_attrs = default_task_attrs
      task_attrs[:task].delete(:task_type_id)
      make_request( task_attrs )
      response.status.should == "400 Bad Request"
    end
    
    it 'should return an error message and a bad request status code if the task type cannot be found' do 
      TaskType.stub!(:find).and_return(nil)
      make_request( default_task_attrs )
      response.status.should == "400 Bad Request"
    end
    
    it 'should pass any non-task parameters on to the task type start url as GET request parameters' do 
      attrs = default_task_attrs
      attrs[:extra_param_one] = 'extra_value_one'
      attrs[:extra_param_two] = 'extra_value_two'
      make_request(attrs)
      redirect_params = get_redirect_params
      redirect_params["extra_param_one"].should == ['extra_value_one']
      redirect_params["extra_param_two"].should == ['extra_value_two']
    end
    
    it 'should pass a task id to the task type start URL' do 
      Task.stub!(:create).and_return(mock_model(Task, :id => 44))
      make_request(default_task_attrs)
      redirect_params = get_redirect_params
      redirect_params['task_id'].should == ["44"]
    end
    
    it 'should store a callback url for the task if one is specified' do 
      callback_url = "http://taskconsumer.example.com/callback"
      Task.should_receive(:create).with("callback_url" => callback_url, "task_type_id" => "a-test-task")
      attrs = default_task_attrs
      attrs[:task][:callback_url] = callback_url
      make_request(attrs)
    end
    
    it 'should store callback parameters for the task if they are specified' do 
      expected_callback_params = { "callback_param_one" => "callback_value_one", 
                                   "callback_param_two" => "callback_value_two" }
      Task.should_receive(:create).with("callback_params" => expected_callback_params, "task_type_id" => "a-test-task")
      attrs = default_task_attrs
      attrs[:task][:callback_params] = {}
      attrs[:task][:callback_params][:callback_param_one] = "callback_value_one"
      attrs[:task][:callback_params][:callback_param_two] = "callback_value_two"
      make_request(attrs)
      
    end
    
  end

  describe 'responding to PUT #update' do 
    
    describe 'when the request has a "status" parameter with value "complete"' do 
      
      before do 
        @data = { 'data_one' => 'data_value_one', 
                  'data_two' => 'data_value_two' }
        @callback_params = { :callback_param_one => "callback_value_one", 
                             :callback_param_two => "callback_value_two" }
        @mock_task = mock_model(Task, :callback_url => "http://taskconsumer.example.com/callback", 
                                      :callback_params => @callback_params,
                                      :update_attribute => true, 
                                      :return_url => 'http://taskconsumer.example.com/return')
        Task.stub!(:find).and_return(@mock_task)
      end
            
      def make_request
        put :update, { :id => 55, :task => { :status => :complete, :data => @data } }
      end      
            
      it 'should set the status of the task to complete if it is not complete' do 
        @mock_task.should_receive(:update_attribute).with(:status, :complete)
        make_request
      end
      
      it 'should issue a POST request to the callback URL of the task containing any callback params defined on the task, any data passed to the request, the task id, and a status param of "complete"' do 
        expected_params = @callback_params.clone
        expected_params[:data] = @data
        expected_params[:status] = :complete
        expected_params[:task_id] = "55"
        controller.should_receive(:external_json_request).with('http://taskconsumer.example.com/callback', 
                                                               :post, 
                                                               expected_params)
        make_request
      end
      
      it "should not try to post to the callback URL if there isn't one" do 
        @mock_task.stub!(:callback_url).and_return(nil)
        controller.should_not_receive(:external_json_request)
        make_request
      end

      it 'should redirect the request to the return URL of the task' do
        make_request
        response.should redirect_to("http://taskconsumer.example.com/return")
      end
   
      it 'should return a success code if there is no return URL for the task' do 
        @mock_task.stub!(:return_url).and_return(nil)
        make_request
        response.status.should == "200 OK"
      end
      
    end
  
  end
  
end