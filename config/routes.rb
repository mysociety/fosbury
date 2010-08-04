ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  map.root :controller => :task_types, :action => :index
  map.resources :task_types
  map.resources :tasks, :except => [:destroy, :index]
end
