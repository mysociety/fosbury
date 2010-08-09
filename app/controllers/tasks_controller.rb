require 'net/http'
require 'uri'

class TasksController < ApplicationController
  protect_from_forgery :only => []
  before_filter :check_api_key
  before_filter :find_task, :only => [:show, :update]
  before_filter :check_task_type_provider_api_key, :only => [:update]
  before_filter :check_provider_or_setter_api_key, :only => [:show]

  def show 
    respond_to do |format|
      format.json{ render_json(@task) }
      format.html do
        render :text => @task.to_yaml.to_s
      end
    end
  end
  
  def create
    if params[:task] and params[:task][:task_type_id]
      @task_type = TaskType.find(params[:task].delete(:task_type_id))
    end
    if @task_type 
      params[:task][:task_type_id] = @task_type.id
      params[:task][:setter] = @application
      @task = Task.create(params[:task])   
      if @task 
        respond_to do |format|
          format.json{ render_json(@task) }
        end
        return
      end
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
  
  def render_json object
    render :json => object.to_json(:methods => [ :status, :start_url, :provider_name, :setter_name ] ) 
  end
  
  def check_task_type_provider_api_key
    if @application && @task.task_type.provider == @application
      return true
    end
    bad_api_key
  end
  
  def check_provider_or_setter_api_key
    if @application 
      if @task.task_type.provider == @application
        return true
      end
      if @task.setter == @application
        return true
      end
    end
    bad_api_key
    return false
  end
  
  def find_task
    @task = Task.find(params[:id])
  end
  
  def complete_task
    @task.update_attribute(:status, :complete)
    @task.update_attribute(:task_data, params[:task][:task_data])
    if @task.callback_url
      json_params = @task.callback_params
      if params[:task][:task_data]
        json_params[:task_data] = params[:task][:task_data]
      end
      json_params[:status] = :complete
      json_params[:task_id] = params[:id]
      if @task.setter != @task.task_type.provider 
        response, response_data = external_json_request(@task.callback_url, :post, @task.callback_params)
      end
    end
    respond_to do |format|
      format.json{ render_json(@task) }
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