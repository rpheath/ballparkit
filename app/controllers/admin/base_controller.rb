class Admin::BaseController < ApplicationController
  before_filter :authorize
  
protected
  def authorize
    raise Ballpark::NotAuthorized unless login_required && current_user.admin?
  rescue Ballpark::NotAuthorized => e
    warning e.message
    redirect_to estimates_path
  end
end