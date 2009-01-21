module Ballpark
  module Authentication
    module System
      protected
        def logged_in?
          !!current_user
        end
    
        def current_user
          @current_user ||= login_from_session unless @current_user == false
        end
    
        def current_user=(new_user)
          session[:user_id] = (new_user ? new_user.id : nil)
          @current_user = new_user || false
        end
    
        def login_required
          logged_in? || access_denied
        end
    
        def access_denied
          flash[:error] = "Access denied. You must first login."
          redirect_to login_path
        end

        def self.included(base)
          base.send :helper_method, :current_user, :logged_in?, :authorized? if base.respond_to? :helper_method
        end
  
      private    
        def login_from_session
          self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]     
        end
        
        def logout!
          current_user = false
          reset_session
        end
        
        def reset_session
          session[:user_id] = nil
        end
    end
  end
end