module Ballpark
  class Error < StandardError
    class << self
      @message = nil
      
      # sets/gets the default message for this class
      # (the message is simply retrieved when the argument is nil)
      def message(msg=nil)
        msg.nil? ? @message : self.message = msg
      end
      
      # sets the default message
      def message=(msg)
        @message = msg
      end
    end
    
    # override the default initializer for errors
    # to set the message to default if necessary
    def initialize(message=nil)
      @message = message || self.class.message
    end
    
    # returns the message for this exception
    # (defaulting to super)
    def message
      @message || super
    end
  end
end