module Ballpark
  module Authentication
    module OpenId
      protected
        def openid_authentication(identity_url = params[:openid_url])
          authenticate_with_open_id(identity_url, :required => [:fullname, :email], :optional => [:nickname]) do |result, openid_url, sreg|
            if result.successful?
              if self.current_user = User.login(openid_url, sreg)
                successful_login
              else
                failed_login "Sorry, Ballpark was unable to log you in."
              end
            else
              failed_login result.message
            end
          end
        end
        
      private
        def successful_login(message = nil)
          notice message || "Successfully logged in as #{current_user.name}"
          redirect_to root_path
        end

        def failed_login(message = nil)
          error message || "Sorry, Ballpark was unable to log you in at this time."
          redirect_to login_path
        end
    end
  end
end