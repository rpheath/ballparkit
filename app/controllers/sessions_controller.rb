class SessionsController < ApplicationController
  skip_before_filter :login_required
  
  def new
    render
  end
  
  def create
    openid_authentication
  rescue Exception => e
    error e.message
    redirect_to login_path
  end
  
  def destroy
    logout!
    redirect_to login_path
  end
end
