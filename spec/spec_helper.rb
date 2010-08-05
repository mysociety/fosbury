# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

require 'spec/shared/auth_spec_helpers'

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

end

def stub_applications_for_api_keys
  # set up a valid application for the API key
  @provider_application = mock_model(Application, :id => 33, :name => "Provider app")
  Application.stub!(:find_by_api_key).with('Provider API key').and_return(@provider_application)
  @other_application = mock_model(Application, :id => 44, :name => "Other app")
  Application.stub!(:find_by_api_key).with('Other API key').and_return(@other_application)
  @setter_application = mock_model(Application, :id => 55, :name => "Setter app")
  Application.stub!(:find_by_api_key).with('Setter API key').and_return(@setter_application)  
end

def auth(api_key)
  request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("A Test Application:#{api_key}")
end

def response_json
  JSON.parse(@response.body)
end
