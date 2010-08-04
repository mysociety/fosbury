require 'spec_helper'

describe TaskTypesController do
  
  def default_tasktype_attrs
    { :name => 'A test task type', 
      :start_url => 'http://www.example.com/test_task_start' }
  end
  
  before do 
    stub_applications_for_api_keys
  end
  
  describe 'responding to POST #create' do 
    
    def make_request(data, api_key='Provider API key')
      data[:api_key] = api_key
      post :create, data
    end
    
    it_should_behave_like "an action requiring an API key"
    
    it 'should set the provider of the task type' do 
      make_request( :task_type => default_tasktype_attrs )
      response_json["provider_id"].should == 33
    end
    
    it 'should create a task type given simple json params' do 
      TaskType.should_receive(:create)
      make_request( :task_type => default_tasktype_attrs )
    end
    
    it 'should store task parameters sent as part of the task type attributes' do 
      tasktype_attrs = default_tasktype_attrs
      tasktype_attrs[:parameters_attributes] = [{ :name => 'Parameter one', 
                                                  :required => true, 
                                                  :description => 'A string parameter' }, 
                                                { :name => 'Parameter two', 
                                                  :required => false, 
                                                  :description => 'An integer parameter' }]
      make_request( :task_type => tasktype_attrs )
      @response.status.should == "200 OK"
      response_json["parameters"].size.should == 2
    end
    
    it 'should return an error in json if sent malformed parameters' do 
      tasktype_attrs = default_tasktype_attrs
      tasktype_attrs[:parameters_attributes] = [{ :name => 'Parameter one', 
                                                  :bad_param => true, 
                                                  :description => 'A string parameter' }]
      make_request( :task_type => tasktype_attrs )
      @response.status.should == "500 Internal Server Error"
      response_json['error']['message'].should == 'unknown attribute: bad_param'
    end
    
  end
  
  describe 'responding to PUT #update' do 
    
    before do
      mock_task_type = mock_model(TaskType, :provider => @provider_application)
      TaskType.stub!(:find).and_return(mock_task_type)
    end
  
    def make_request(data={}, api_key='Provider API key')
      data[:id] = 'a-test-task' if !data[:id]
      data[:api_key] = api_key
      put :update, data
    end
    
    it_should_behave_like "an action that can only be done by the task type provider"
    
  end
  
  describe 'responding to DELETE #destroy' do 
    
    before do
      mock_task_type = mock_model(TaskType, :provider => @provider_application)
      TaskType.stub!(:find).and_return(mock_task_type)
    end
  
    def make_request(data={}, api_key='Provider API key')
      data[:id] = 'a-test-task' if !data[:id]
      data[:api_key] = api_key
      delete :destroy, data
    end
    
    it_should_behave_like "an action that can only be done by the task type provider"
    
  end
  
  describe 'responding to GET #show' do 
  
    before do 
      TaskType.stub!(:find).and_return(TaskType.new(default_tasktype_attrs))
    end
    
    def make_request
      get :show, { :id => "a-test-task" }
    end
    
    it 'should return a json hash of task type attributes' do 
      make_request
      response_json["name"].should == default_tasktype_attrs[:name]
      response_json["start_url"].should == default_tasktype_attrs[:start_url]
    end
    
  end
  
  describe 'responding to GET #index' do 
      
    def make_request
      get :index
    end
    
    it 'should ask for all the task types' do 
      TaskType.should_receive(:find).with(:all).and_return([])
      make_request
    end
    
    it 'should return a json list of task type hashes for all task types' do 
      mock_task_type = mock_model(TaskType, :to_json => '{"my_json": "json"}')
      TaskType.stub!(:find).with(:all).and_return([mock_task_type, mock_task_type])
      make_request
      response_json.should == [{"my_json"=>"json"}, {"my_json"=>"json"}]
    end
      
  end

end