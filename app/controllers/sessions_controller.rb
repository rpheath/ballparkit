class SessionsController < ApplicationController
  layout 'public'
  
  skip_before_filter :login_required
  
  def new
    redirect_to estimates_path if logged_in?
  end
  
  def create
    openid_authentication
  rescue
    redirect_to login_path
  end
  
  def destroy
    logout!
    notice "You have been logged out successfully"
    redirect_to login_path
  end
end
