class Task < ActiveRecord::Base
  belongs_to :task_type
  belongs_to :task_provider
  validates_presence_of :task_type_id
  serialize :callback_params
  
  STATUS_CODES = { 0 => 'In Progress', 
                   1 => 'Complete' }
  
  SYMBOL_TO_STATUS_CODE = STATUS_CODES.inject({}) do |hash, (code, message)|
    hash[message.gsub(/ /, "").underscore.to_sym] = code
    hash
  end
  
  STATUS_CODE_TO_SYMBOL = SYMBOL_TO_STATUS_CODE.invert
  
  def status
    STATUS_CODE_TO_SYMBOL[status_code]
  end
  
  def status=(symbol)
    code = SYMBOL_TO_STATUS_CODE[symbol]
    if code.nil? 
      raise "Unknown status for task #{symbol}"
    end
    self.status_code = code
  end
  
  def status_description
    STATUS_CODES[status_code]
  end
  
end
