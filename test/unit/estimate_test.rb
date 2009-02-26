require 'test_helper'

class EstimateTest < ActiveSupport::TestCase
  private
    def setup
      @estimate = Estimate.new(:title => 'ACME Inc.')
      Estimate.delete_all
    end
    
    def create_estimates(count = 5)
      count.times { |n| Estimate.create(:user_id => users(:ryan).id, :title => "Estimate #{n}") }
    end
    
    def tasks(estimate_id)
      [
        Task.new(:estimate_id => estimate_id, :description => 'Task 1', :hours => '1', :rate => '$10'),
        Task.new(:estimate_id => estimate_id, :description => 'Task 2', :hours => '2', :rate => '$10'),
        Task.new(:estimate_id => estimate_id, :description => 'Task 3', :hours => '3', :rate => '$10')
      ]
    end
    
  public
    test "should be a valid estimate" do
      assert_valid @estimate
    end
    
    test "should require an estimate title" do
      assert_no_difference 'Estimate.count' do
        e = Estimate.create
        assert e.errors.on(:title)
      end
    end
    
    test "should list estimates in descending order by id" do
      create_estimates
      
      estimate_ids = Estimate.paginated(users(:ryan), 1).map(&:id)
      assert_equal estimate_ids.first, estimate_ids.max
    end
    
    test "should support pagination" do
      create_estimates
      Estimate.stubs(:per_page).returns(2)
      
      estimates = Estimate.paginated(users(:ryan), 1)
      assert_equal 2, estimates.size.to_i
    end
    
    test "should create a unique SHA1 token after create" do
      assert_nil @estimate.token
      
      @estimate.save
      
      assert_not_nil @estimate.token
      assert_match /^[a-zA-Z0-9]{40}$/, @estimate.token
    end
    
    test "should find an estimate by a token" do
      @estimate.save
      
      new_estimate = Estimate.find_by_token!(@estimate.token)
      assert_equal @estimate, new_estimate
    end
    
    test "should raise InvalidToken error when invalid tokens" do
      begin
        @estimate.save
        Estimate.find_by_token!(@estimate.token.chomp)
      rescue Ballpark::InvalidToken => e
        assert e.match(/invalid token/i)
      end      
    end
    
    test "should total hours" do
      @estimate.save
      @estimate.expects(:tasks).returns(tasks(@estimate.id))
      
      assert_equal '6.0', @estimate.total_hours
    end
    
    test "should total price" do
      @estimate.save
      @estimate.expects(:tasks).returns(tasks(@estimate.id))
      
      assert_equal '60.0', @estimate.total_price
    end
    
    test "should return 0 for totals other than hours or price" do
      assert_equal '0', @estimate.send(:total, :other)
    end
    
    test "should have a discount" do
      @estimate.discount = '10'
      assert @estimate.has_discount?
    end
    
    test "should return a total including the discount" do
      @estimate.discount = '10'
      @estimate.stubs(:tasks).returns(tasks(@estimate.id))
      
      assert_equal '54.0', @estimate.total_price
    end
    
    test "should return a sub-total (not include discount)" do
      @estimate.discount = '10'
      @estimate.stubs(:tasks).returns(tasks(@estimate.id))
      
      assert_equal '60.0', @estimate.sub_total
    end
    
    test "sub-total should equal total price if no discount" do
      @estimate.stubs(:tasks).returns(tasks(@estimate.id))
      assert_equal @estimate.sub_total, @estimate.total_price
    end
end
