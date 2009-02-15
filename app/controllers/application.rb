class ApplicationController < ActionController::Base
  include Ballpark::Authentication::System
  include Ballpark::Authentication::OpenId
  
  helper :all

  protect_from_forgery # :secret => 'ef9f1e9e8f915529e00e54429916d821'
  
  before_filter :login_required
  before_filter :configure_time_zone
  
  user_stamp Estimate, Task
  
protected
  def ensure_permission!(object)
    return if object.new_record? || current_user.owns?(object)
    
    warning "Sorry, you don't have permission to perform that action"
    redirect_to send("#{controller_name}_path")
  end
  
  def configure_time_zone
    Time.zone = current_user.setting.time_zone if logged_in? && current_user.has_time_zone?
  end
end
