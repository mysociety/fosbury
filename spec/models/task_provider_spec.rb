# == Schema Information
# Schema version: 20100803101541
#
# Table name: applications
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  api_key    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Application do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :api_key => "value for api_key"
    }
  end

  it "should create a new instance given valid attributes" do
    Application.create!(@valid_attributes)
  end
end
