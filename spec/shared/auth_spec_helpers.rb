module SharedBehaviours
  
  module AuthSpecHelpers
    
    shared_examples_for "an action requiring an API key" do 
      
      it 'should return a forbidden status code and appropriate error message if the API key is missing' do 
        make_request({}, api_key=nil)
        response.status.should == "403 Forbidden"
        response_json['error']['message'].should == "Missing or invalid API key"
      end

      it 'should return a forbidden status code and appropriate error message if the API key is invalid' do 
        make_request({}, api_key='Bad API key')
        response.status.should == "403 Forbidden"
        response_json['error']['message'].should == "Missing or invalid API key"
      end
      
    end  
  end
  
  shared_examples_for "an action that can only be done by the task type provider" do 
  
    it_should_behave_like "an action requiring an API key"
    
    it 'should return a forbidden status code and appropriate error message if the API key does not belong to the task type provider' do 
      make_request({}, api_key='Other API key')
      response.status.should == "403 Forbidden"
      response_json['error']['message'].should == "Missing or invalid API key"
    end
    
    it 'should not return a forbidden status code if the API key belongs to the task type provider' do
      make_request({}, api_key='Provider API key')
      response.status.should_not == "403 Forbidden"
    end 
    
  end
  
  shared_examples_for "an action that can only be done by the task type provider or task consumer" do 
  
    it_should_behave_like "an action that can only be done by the task type provider"
    
    it 'should not return a forbidden status code if the API key belongs to the task consumer' do 
      make_request({}, api_key='Consumer API key')
      response.status.should_not == "403 Forbidden"
    end
    
  end

end