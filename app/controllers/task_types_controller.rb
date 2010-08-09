class TaskTypesController < ApplicationController
  
  before_filter :check_api_key, :except => [:index, :show]
  before_filter :find_task_type, :only => [:show, :update, :destroy]
  before_filter :check_provider_api_key, :only => [:update, :destroy]

  def index
    @task_types = TaskType.find(:all)
    respond_to do |format|
      format.json{ render_json(@task_types) }
      format.html{ }
    end
  end

  def show 
    respond_to do |format|
      format.json{ render_json(@task_type) }
      format.html{ }
    end
  end
  
  def create
    params['task_type']['provider_id'] = @application.id
    @task_type = TaskType.create(params['task_type'])
    respond_to do |format|
      format.json { render_json(@task_type) }
    end
  end
  
  def update
  end
  
  def destroy
  end
  
  private 
  
  def render_json object
    render :json => object.to_json( :include => :parameter_types )
  end
  
  def find_task_type
    @task_type = TaskType.find(params[:id])
  end
  
  def check_provider_api_key
    if @application && @task_type.provider == @application
      return true
    end
    bad_api_key
  end
end