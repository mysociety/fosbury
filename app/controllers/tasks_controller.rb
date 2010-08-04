require 'net/http'
require 'uri'

class TasksController < ApplicationController
  protect_from_forgery :only => []
  before_filter :check_api_key
  before_filter :find_task, :only => [:show, :update]
  before_filter :check_task_type_provider_api_key, :only => [:update]
  before_filter :check_provider_or_consumer_api_key, :only => [:show]

  def show 
    respond_to do |format|
      format.json{ render :json => @task.to_json(:methods => :status) }
    end
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
      querystring_params = params
      querystring_params['task_id'] = @task.id.to_s
      querystring = querystring_params.map{ |k,v| "#{CGI.escape(k)}=#{CGI.escape(v)}" }.join("&")
      redirect_url = @task_type.start_url
      if !querystring.blank?
        redirect_url += "?#{querystring}" 
      end
      redirect_to redirect_url
      return 
    end
    render :status => :bad_request and return false
  end
  
  def update
    if params[:id]
      if params[:task] and params[:task][:status]
        if params[:task][:status].to_sym == :complete
          complete_task
        end
      end
    end
  end
  
  private
  
  def check_task_type_provider_api_key
    if @application && @task.task_type.provider == @application
      return true
    end
    bad_api_key
  end
  
  def check_provider_or_consumer_api_key
    if @application 
      if @task.task_type.provider == @application
        return true
      end
      if @task.consumer == @application
        return true
      end
    end
    bad_api_key
  end
  
  def find_task
    @task = Task.find(params[:id])
  end
  
  def complete_task
    @task.update_attribute(:status, :complete)
    if @task.callback_url
      json_params = @task.callback_params
      if params[:task][:data]
        json_params[:data] = params[:task][:data]
      end
      json_params[:status] = :complete
      json_params[:task_id] = params[:id]
      response, response_data = external_json_request(@task.callback_url, :post, @task.callback_params)
    end
    if @task.return_url
      redirect_to @task.return_url
    else
      head :ok
      return false
    end
  end
  
  def external_json_request(uri_string, method=:get, request_data={})
    uri = URI.parse(uri_string)
    http = Net::HTTP.new(uri.host, uri.port)
    initheader = { 'Content-Type' =>'application/json' } 
    if method == :get
      response, response_data = http.get(uri.path, initheader)
    elsif method == :post
      response, response_data = http.post(uri.path, request_data.to_json, initheader)
    else
      raise NotImplementedError, "HTTP method #{method} not implemented"
    end
    RAILS_DEFAULT_LOGGER.info("MADE EXTERNAL JSON REQUEST #{request_data.to_json}")
    return response, response_data
  end
  
end