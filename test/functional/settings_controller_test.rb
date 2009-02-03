require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  private
    def setup
      @current_user, @setting = users(:ryan), settings(:default)
      
      @controller.stubs(:current_user).returns(@current_user)
      @current_user.stubs(:setting).returns(@setting)
    end
    
    def login!
      @controller.stubs(:login_required).returns(true)
    end
  
  public
    test "should not load settings without being logged in" do
      @controller.stubs(:current_user).returns(false)
      
      get :index
      assert_response :redirect
    end
    
    test "should load index on GET to /settings" do
      login!
      
      get :index
      assert assigns(:setting)
      assert assigns(:tasks)
      assert_response :success
    end
    
    test "should find the @setting object by id on GET to /edit/1" do
      login!
      
      Setting.expects(:find).with('1').returns(@setting)
      
      get :edit, :id => '1'
      assert assigns(:setting)
    end
    
    test "should not allow editing of settings not belonging to logged in user" do
      login!
      
      Setting.stubs(:find).with('1').returns(@setting)
      @current_user.expects(:owns?).returns(false)
      
      get :edit, :id => '1'
      assert_response :redirect
    end
end