class TaskTypesController < ApplicationController
  
  before_filter :check_api_key, :except => [:index, :show]

  def index
    @task_types = TaskType.find(:all)
    respond_to do |format|
      format.json{ render_json(@task_types) }
    end
  end

  def show 
    @task_type = TaskType.find(params[:id])
    respond_to do |format|
      format.json{ render_json(@task_type) }
    end
  end
  
  def create
    params['task_type']['task_provider_id'] = @task_provider.id
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
    render :json => object.to_json( :include => :parameters )
  end
end