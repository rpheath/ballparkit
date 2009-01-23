class ApplicationController < ActionController::Base
  include Ballpark::Authentication::System
  include Ballpark::Authentication::OpenId
  
  helper :all

  protect_from_forgery # :secret => 'ef9f1e9e8f915529e00e54429916d821'
  
  before_filter :login_required
  
  user_stamp Estimate, Task
end
