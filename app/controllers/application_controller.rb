# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # Return errors in JSON for JSON requests
  rescue_from StandardError do |exception|
    respond_to do |format|
      format.json do 
        exception_attributes = { :error => { :message => exception.message } }
        # include backtrace in development
        if ActionController::Base.consider_all_requests_local
          exception_attributes[:backtrace] = exception.backtrace
        end
        render :json => exception_attributes, :status => 500 
      end
      # treat errors as usual for HTML requests
      format.html do 
        if ActionController::Base.consider_all_requests_local
          rescue_action_locally(exception)
        else  
          rescue_action_in_public(exception)
        end
      end
    end
  end
  
  protected 
  
  def check_api_key
    if params[:api_key] and @task_provider = TaskProvider.find_by_api_key(params[:api_key])
      return true
    end
    render :json => { :error => { :message => t(:bad_api_key) } }.to_json, :status => :forbidden 
    return false
  end
  
end
