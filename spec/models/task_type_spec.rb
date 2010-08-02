require 'spec_helper'

describe TaskType do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :callback_url => "value for callback_url"
    }
  end

  it "should create a new instance given valid attributes" do
    TaskType.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: task_types
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  cached_slug  :string(255)
#  callback_url :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

