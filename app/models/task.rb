# == Schema Information
# Schema version: 20100803101541
#
# Table name: tasks
#
#  id              :integer         not null, primary key
#  task_type_id    :integer
#  created_at      :datetime
#  updated_at      :datetime
#  callback_url    :string(255)
#  callback_params :text
#  status_code     :integer         default(0)
#  return_url      :text
#

class Task < ActiveRecord::Base
  belongs_to :task_type
  validates_presence_of :task_type_id
  serialize :callback_params
  serialize :params
  serialize :task_data
  has_many :parameter_types, :class_name => 'TaskParameterType'
  belongs_to :setter, :class_name => 'Application'

  STATUS_CODES = { 0 => 'New', 
                   1 => 'In Progress',
                   2 => 'Complete' }
  
  SYMBOL_TO_STATUS_CODE = STATUS_CODES.inject({}) do |hash, (code, message)|
    hash[message.gsub(/ /, "").underscore.to_sym] = code
    hash
  end
  
  STATUS_CODE_TO_SYMBOL = SYMBOL_TO_STATUS_CODE.invert
  
  def status
    STATUS_CODE_TO_SYMBOL[status_code]
  end
  
  def status=(symbol_or_string)
    code = SYMBOL_TO_STATUS_CODE[symbol_or_string.to_sym]
    if code.nil? 
      raise "Unknown status for task #{symbol}"
    end
    self.status_code = code
  end
  
  def status_description
    STATUS_CODES[status_code]
  end
  
  # Add the parameters supplied for this particular task to the redirect url for the task type
  # to make a start url to begin this task
  def start_url
    if !self.params
      self.params = {}
    end
    querystring_params = self.params
    querystring_params['task_id'] = self.id.to_s
    querystring = querystring_params.map{ |k,v| "#{CGI.escape(k)}=#{CGI.escape(v)}" }.join("&")
    redirect_url = task_type.start_url
    if !querystring.blank?
      redirect_url += "?#{querystring}" 
    end
    redirect_url
  end
  
  def provider_name
    task_type.provider.name
  end
  
  def setter_name
    setter.name
  end
  
end
