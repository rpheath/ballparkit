require File.join(File.dirname(__FILE__), '/../test_helper')

class EstimatesHelperTest < ActionView::TestCase
  private
    def setup
      @estimate, @setting = Estimate.new, Setting.new
      current_user.stubs(:setting).returns(@setting)
      @setting.stubs(:default_rate).returns('75.00')
    
      @estimate.stubs(:new_record?).returns(true)
      @setting.stubs(:use_default_rate?).returns(true)
    end
  
    def current_user
      users(:ryan)
    end

  public
    test "should return default rate for new records" do
      assert_equal '75.00', default_rate
    end
  
    test "should return default rate for any format of price" do
      @setting.stubs(:default_rate).returns('80')
    
      assert_equal '80.00', default_rate
    end
  
    test "should return nil for existing records" do
      @estimate.stubs(:new_record?).returns(false)
    
      assert_nil default_rate
    end
  
    test "should return nil if user settings say not to use default rate" do
      @setting.stubs(:use_default_rate?).returns(false)
    
      assert_nil default_rate
    end
end