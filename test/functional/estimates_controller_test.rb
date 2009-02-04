require 'test_helper'

class EstimatesControllerTest < ActionController::TestCase
  private
    def setup
      @current_user, @setting, @estimate = users(:ryan), settings(:default), estimates(:ballpark)
      
      @controller.stubs(:current_user).returns(@current_user)
      @current_user.stubs(:setting).returns(@setting)
    end
    
  public
    test "should not allow GET to /estimates without being logged in" do
      logout!
      
      get :index
      assert_response :redirect
    end
    
    test "should allow GET to /estimates and assign @estimates variable" do
      login!
      
      get :index
      assert_response :success
      assert assigns(:estimates)
    end
    
    test "should find estimate by id on GET to 'show'" do
      login!
      
      Estimate.expects(:find).with('1').returns(@estimate)
      
      get :show, :id => '1'
      assert assigns(:estimate)
    end
    
    test "should find estimate by id on GET to 'edit'" do
      login!
      
      Estimate.expects(:find).with('1').returns(@estimate)
      
      get :edit, :id => '1'
      assert assigns(:estimate)
    end
    
    test "should support public view of estimate (doesn't require a login)" do
      logout!
      
      token = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
      Estimate.expects(:find_by_token!).with(token).returns(@estimate)
      
      get :by_token, :token => token
      assert assigns(:estimate)
    end
    
    test "should rescue invalid token errors and handle appropriately" do
      logout!
      
      Estimate.expects(:find_by_token!).with('').returns(nil)
      
      begin
        get :by_token, :token => ''
        assert_response :redirect
      rescue ActionView::TemplateError
        assert_nil assigns(:estimate)
      end
    end
    
    test "should build empty tasks when user doesn't have default tasks" do
      login!
      
      get :new
      assert_equal 2, assigns(:estimate).tasks.size.to_i
    end
    
    test "should use default tasks when a user has default tasks" do
      login!
      
      class Defaults
        attr_accessor :tasks, :rate
        
        def initialize(tasks, rate = '75.00')
          @tasks = [tasks]
          @rate  = rate
        end
      end
      
      @current_user.expects(:defaults).at_least(1).returns(Defaults.new(tasks(:misc)))
      
      get :new
      assert_equal 2, assigns(:estimate).tasks.size.to_i
    end
    
    test "should create a short url when creating estimates" do
      Ballpark::UrlShortener.any_instance.expects(:process).once      
      post :create, :estimate => { :title => 'Short URL Test Estimate' }
    end
end
