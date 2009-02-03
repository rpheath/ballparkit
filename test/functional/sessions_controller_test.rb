require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should show login page" do
    get :new
    assert_response :success
  end
  
  test "should refuse login with blank OpenID" do
    post :create, :openid_url => ''
    assert :redirect
    assert_not_nil flash[:error]
  end
  
  test "should refuse login with malformed OpenID" do
    post :create, :openid_url => 'http://'
    assert :redirect
    assert_not_nil flash[:error]
  end
  
  test "should logout successfully" do
    get :destroy
    assert :redirect
    assert_not_nil flash[:notice]
  end
end
