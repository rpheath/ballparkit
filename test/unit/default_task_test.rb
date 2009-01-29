require 'test_helper'

class DefaultTaskTest < ActiveSupport::TestCase
  private
    def setup
      @setting = Setting.create
      
      DefaultTask.create(:setting_id => @setting.id, :description => 'Information Architecture')
      DefaultTask.create(:setting_id => @setting.id, :description => 'XHTML/CSS Development')
      DefaultTask.create(:setting_id => @setting.id, :description => 'Server-side Development')
    end
  
  public
    test "should return true/false for task existence by setting and description (true case)" do
      assert DefaultTask.found?(@setting.id, 'Information Architecture')
    end
    
    test "should return true/false for task existence by setting and description (false case)" do
      assert !DefaultTask.found?(@setting.id, 'Testing & Debugging')
    end
    
    test "should not care if description of task is proper case" do
      assert DefaultTask.found?(@setting.id, 'information architecture')
    end
end
