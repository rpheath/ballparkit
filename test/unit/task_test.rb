require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  private
    def setup
      @task, @user, @setting = tasks(:misc), User.new, Setting.create
      
      @task.stubs(:user).returns(@user)
      @user.stubs(:setting).returns(@setting)
      
      DefaultTask.delete_all
    end
  
  public
    test "should create default tasks if default is selected on update" do
      @task.expects(:user).at_least(2).returns(@user)
      @user.expects(:setting).at_least(2).returns(@setting)
      
      assert_difference 'DefaultTask.count' do
        @task.update_attributes(:default => '1')
      end
    end
    
    test "should delete default tasks if default is de-selected" do
      DefaultTask.create(:setting_id => @setting.id, :description => @task.description)
      
      assert_equal 1, DefaultTask.count
      @task.update_attributes(:default => '0')
      assert_equal 0, DefaultTask.count
    end
    
    test "should not change default tasks if default is not chosen" do
      assert_no_difference 'DefaultTask.count' do
        @task.update_attributes(:description => 'Miscellaneous Things')
      end
    end
    
    test "total should multiply task hours and task rate" do
      assert_equal 250.0, @task.total
    end
    
    test "total should be a Floating point value" do
      assert_kind_of Float, @task.total
    end
    
    test "total should not care about hours and rate format" do
      @task.update_attributes(:hours => '10', :rate => '100')
      
      assert_equal 1000.0, @task.total
      assert_kind_of Float, @task.total
    end
    
    test "rate should not be allowed to have a $ sign" do
      @task.update_attributes(:rate => '$85.00')
      assert_equal '85.00', @task.rate
    end
    
    test "should not fail if rate is nil" do
      @task.update_attributes(:rate => nil)
      assert_equal '', @task.rate
    end
end
