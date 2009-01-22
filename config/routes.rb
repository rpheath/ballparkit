ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'estimates'
  
  map.resource :session
  map.resources :estimates
  map.resources :settings
  
  map.with_options :controller => 'sessions' do |path|
    path.login '/login', :action => 'new'
    path.logout '/logout', :action => 'destroy'
  end
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
