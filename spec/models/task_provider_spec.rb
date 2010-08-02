require 'spec_helper'

describe TaskProvider do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :api_key => "value for api_key"
    }
  end

  it "should create a new instance given valid attributes" do
    TaskProvider.create!(@valid_attributes)
  end
end
