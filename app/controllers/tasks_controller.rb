class TasksController < ApplicationController
  protect_from_forgery :only => []
  
  def index
  end

  def show 
  end
  
  def create
    if params[:task] and params[:task][:task_type_id]
      @task_type = TaskType.find(params[:task][:task_type_id])
    end
    @task = Task.create( params[:task] )    
    if @task and @task_type
      # remove the fosbury params
      [:task, :action, :controller].each{ |key| params.delete(key) } 
      
      # make a querystring out of the rest
      querystring = params.map{|k,v| "#{CGI.escape(k)}=#{CGI.escape(v)}"}.join("&")
      redirect_url = @task_type.callback_url
      if !querystring.blank?
        redirect_url += "?#{querystring}" 
      end
      redirect_to redirect_url
      return 
    end
    render :status => :bad_request and return false
  end
  
  def update
  end
  
  def destroy
  end
  
end