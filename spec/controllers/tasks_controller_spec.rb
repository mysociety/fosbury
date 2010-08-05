require 'spec_helper'

describe TasksController do

  before do 
    # Don't make any external JSON requests during testing
    controller.stub!(:external_json_request)
    stub_applications_for_api_keys
  end
  
  describe 'responding to GET #show' do 

    before do
      @mock_task = mock_model(Task, :to_json => {},
                                   :task_type => mock_model(TaskType, :provider => @provider_application),
                                   :setter => @setter_application)
      Task.stub!(:find).and_return(@mock_task)
    end
    
    def make_request(data, api_key='Provider API key')
      default_data = { :id => 66 }
      data = default_data if data.empty?
      auth(api_key)
      get :show, data
    end
    
    it_should_behave_like "an action that can only be done by the task type provider or task setter"

  end
  
  describe 'responding to POST #create' do 

    before do 
      mock_task_type = mock_model(TaskType, :start_url => 'http://taskprovider.example.com/start', 
                                            :id => 22,
                                            :provider => @provider_application)
      TaskType.stub!(:find).and_return(mock_task_type)
    end
    
    def make_request(data, api_key='Provider API key')
      auth(api_key)
      post :create, data
    end
    
    def default_task_attrs
     { :task => { :task_type_id => "a-test-task",
                  :params => {:extra_param_one => 'extra_value_one',
                              :extra_param_two => 'extra_value_two'} } }
    end
    
    def get_redirect_params
      redirect = response.redirected_to
      CGI.parse(redirect.split("?")[1])
    end
    
    def get_redirect_path
      redirect = response.redirected_to
      redirect.split("?")[0]
    end
    
    it_should_behave_like "an action requiring an API key"
    
    it 'should return the task created' do
      make_request(default_task_attrs)
      response_json['task'].should_not be_nil
    end
    
    it 'should create a new task associated with the correct task type' do 
      make_request(default_task_attrs)
      assigns[:task].task_type_id.should == 22
    end
  
    it 'should return an error message and a bad request status code if no task type id is given' do 
      task_attrs = default_task_attrs
      task_attrs[:task].delete(:task_type_id)
      make_request(task_attrs)
      response.status.should == "400 Bad Request"
    end
    
    it 'should return an error message and a bad request status code if the task type cannot be found' do 
      TaskType.stub!(:find).and_return(nil)
      make_request(default_task_attrs)
      response.status.should == "400 Bad Request"
    end
    
    it 'should pass any non-task parameters on to the task type start url as GET request parameters' do 
      attrs = default_task_attrs
      make_request(attrs)
      start_url = response_json['task']['start_url']
      params = CGI.parse(start_url.split('?')[1])
      params['extra_param_one'].should == ['extra_value_one']
      params['extra_param_two'].should == ['extra_value_two']
    end
    
    it 'should pass a task id to the task type start URL' do 
      make_request(default_task_attrs)
      start_url = response_json['task']['start_url']
      params = CGI.parse(start_url.split('?')[1])
      params['task_id'].should_not be_nil
    end
    
    it 'should store a callback url for the task if one is specified' do 
      callback_url = "http://tasksetter.example.com/callback"
      attrs = default_task_attrs
      attrs[:task][:callback_url] = callback_url
      make_request(attrs)
      assigns[:task].callback_url.should == callback_url
    end
    
    it 'should store callback parameters for the task if they are specified' do 
      expected_callback_params = { "callback_param_one" => "callback_value_one", 
                                   "callback_param_two" => "callback_value_two" }
      attrs = default_task_attrs
      attrs[:task][:callback_params] = {}
      attrs[:task][:callback_params][:callback_param_one] = "callback_value_one"
      attrs[:task][:callback_params][:callback_param_two] = "callback_value_two"
      make_request(attrs)
      assigns[:task].callback_params.should == expected_callback_params
    end
    
    it 'should store the setter of the task to the owner of the API key used in the request' do 
      make_request(default_task_attrs, 'Setter API key')
      assigns[:task].setter.should == @setter_application
    end
    
  end

  describe 'responding to PUT #update' do 

    before do 
      @task_data = { 'data_one' => 'data_value_one', 
                     'data_two' => 'data_value_two' }
      @callback_params = { :callback_param_one => "callback_value_one", 
                           :callback_param_two => "callback_value_two" }
      @mock_task = mock_model(Task, :callback_url => "http://tasksetter.example.com/callback", 
                                    :callback_params => @callback_params,
                                    :update_attribute => true, 
                                    :return_url => 'http://tasksetter.example.com/return', 
                                    :setter => @setter_application,
                                    :task_type => mock_model(TaskType, :provider => @provider_application),
                                    :to_json => {'task' => {}})
      Task.stub!(:find).and_return(@mock_task)
    end
    
    def make_request(data={}, api_key='Provider API key')
      default_data = { :id => 55, :task => { :status => :complete, :task_data => @task_data } }
      data = default_data if data.empty?
      auth(api_key)
      put :update, data
    end
        
    it_should_behave_like "an action that can only be done by the task type provider"
    
    describe 'when the request has a "status" parameter with value "complete"' do 
      
      it 'should set the status of the task to complete if it is not complete' do 
        @mock_task.should_receive(:update_attribute).with(:status, :complete)
        make_request
      end
      
      it 'should issue a POST request to the callback URL of the task containing any callback params defined on the task, any data passed to the request, the task id, and a status param of "complete"' do 
        expected_params = @callback_params.clone
        expected_params[:task_data] = @task_data
        expected_params[:status] = :complete
        expected_params[:task_id] = "55"
        controller.should_receive(:external_json_request).with('http://tasksetter.example.com/callback', 
                                                               :post, 
                                                               expected_params)
        make_request
      end
      
      it "should not try to post to the callback URL if there isn't one" do 
        @mock_task.stub!(:callback_url).and_return(nil)
        controller.should_not_receive(:external_json_request)
        make_request
      end
      
      it 'should not try to post to the callback URL if the task setter is the same as the task provider' do 
        @mock_task.stub!(:setter).and_return(@provider_application)
        controller.should_not_receive(:external_json_request)
        make_request
      end

      it 'should return the task data' do
        make_request
        response_json['task'].should_not be_nil
      end
   
      it 'should return a success code if there is no return URL for the task' do 
        @mock_task.stub!(:return_url).and_return(nil)
        make_request
        response.status.should == "200 OK"
      end
      
    end
  
  end
  
end