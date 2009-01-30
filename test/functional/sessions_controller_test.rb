require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should show login page" do
    get :new
    assert_response :success
  end
end
