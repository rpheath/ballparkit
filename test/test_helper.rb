ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'action_view/test_case'
require 'mocha'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  fixtures :all
  
  def login!
    @controller.stubs(:login_required).returns(true)
  end
  
  def logout!
    @controller.stubs(:current_user).returns(false)    
  end
end