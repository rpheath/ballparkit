require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  private
    def setup
      @current_user = users(:ryan)
      
      @controller.stubs(:current_user).returns(@current_user)
      @current_user.stubs(:admin?).returns(true)
    end
  
  public
    test "should not allow non-admin users to access admin area" do
      @current_user.stubs(:admin?).returns(false)
      
      get :index
      assert_response :redirect
    end
    
    test "should allow admin users to access admin area" do
      get :index
      assert_response :success
    end
    
    test "should have users array on GET to index" do
      get :index
      assert_response :success
      assert assigns(:users)
    end
end
