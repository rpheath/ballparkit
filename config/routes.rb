ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'estimates'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
