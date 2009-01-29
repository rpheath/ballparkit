require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  private
    def setup
      @setting = Setting.create
      
      DefaultTask.delete_all
            
      5.times do |number|
        DefaultTask.create(
          :setting_id => @setting.id,
          :description => "Description #{number}"
        )
      end
    end
    
  public
    test "should delete all default tasks if clear_all is selected" do
      assert_equal 5, DefaultTask.count
      @setting.update_attributes(:clear_all => '1')
      assert_equal 0, DefaultTask.count
    end
    
    test "should only delete default tasks belonging to that setting" do
      DefaultTask.first.update_attribute(:setting_id, 0)
      
      assert_equal 5, DefaultTask.count
      @setting.update_attributes(:clear_all => '1')
      assert_equal 1, DefaultTask.count
    end
    
    test "should leave default tasks alone if clear_all is not selected" do
      assert_no_difference 'DefaultTask.count' do
        @setting.update_attributes(:default_rate => '500')
      end
    end
    
    test "default_rate should not be allowed to have a $ sign" do
      @setting.update_attributes(:default_rate => '$100.00')
      assert_equal '100.00', @setting.default_rate
    end
    
    test "should not fail if default_rate is nil" do
      @setting.update_attributes(:default_rate => nil)
      assert_equal '', @setting.default_rate
    end
end
