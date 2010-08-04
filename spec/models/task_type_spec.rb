# == Schema Information
# Schema version: 20100803101541
#
# Table name: task_types
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  cached_slug      :string(255)
#  start_url        :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  provider_id :integer
#

require 'spec_helper'

describe TaskType do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :start_url => "value for start_url"
    }
  end

  it "should create a new instance given valid attributes" do
    TaskType.create!(@valid_attributes)
  end
end

