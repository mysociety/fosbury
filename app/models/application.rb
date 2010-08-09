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

class Application < ActiveRecord::Base
  has_many :tasks
  before_create :generate_api_key
  
  def generate_api_key
    self.api_key = MySociety::Util.generate_token
  end
  
end
