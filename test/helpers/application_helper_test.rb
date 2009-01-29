require File.join(File.dirname(__FILE__), '/../test_helper')

class ApplicationHelperTest < ActionView::TestCase
  test "should set page title without a block" do
    response = page_title('Heading')
    
    assert_equal '<h1>Heading</h1>', response
  end
  
  test "should set page title with a block" do
    response = page_title do
      '<em>Heading</em>'
    end
    
    assert_equal '<h1><em>Heading</em></h1>', response
  end
  
  test "should section content with a header and yield content" do
    response = section('User Registration') do
      '<input type="text" name="fullname" />'
    end

    assert_equal '<input type="text" name="fullname" />', response
  end
end