require 'test_helper'

class UserTest < ActiveSupport::TestCase  
  private
    def attributes
      HashWithIndifferentAccess.new({ 
        :identity_url => 'http://example.myopenid.com', 
        :nickname => 'rpheath',
        :fullname => 'Ryan Heath',
        :email => 'ryan@rpheath.com'
      })
    end

    def new_user(attrs = {})
      User.new(attributes.merge(attrs))
    end

    def create_user(attrs = {})
      User.create(attributes.merge(attrs))
    end
    
  public
    test "should be a valid user" do
      assert_valid new_user
    end
  
    test "should require and have errors on identity_url" do
      assert_no_difference 'User.count' do
        u = create_user(:identity_url => nil)
        assert u.errors.on(:identity_url)
      end
    end
      
    test "should require and have errors on nickname" do
      assert_no_difference 'User.count' do
        u = create_user(:nickname => nil)
        assert u.errors.on(:nickname)
      end
    end
      
    test "should require and have errors on email" do
      assert_no_difference 'User.count' do
        u = create_user(:email => nil)
        assert u.errors.on(:email)
      end
    end
      
    test "should normalize identity_url with missing http://" do
      u = create_user :identity_url => 'example.myopenid.com'
      assert_equal 'http://example.myopenid.com/', u.identity_url
    end
      
    test "should normalize identity_url with trailing slash" do
      u = create_user :identity_url => 'example.myopenid.com/'
      assert_equal 'http://example.myopenid.com/', u.identity_url
    end
      
    test "should be an invalid identity_url" do
      begin
        new_user(:identity_url => 'invalid_url').save
      rescue OpenIdAuthentication::InvalidOpenId => e
        assert_equal 'http://invalid_url is not an OpenID identifier', e.message
      end
    end
    
    test "should not be an admin by default" do
      u = create_user
      
      assert !u.admin?
    end
    
    test "should be an admin if super_user flag is set" do
      u = create_user
      u.update_attribute(:super_user, true)
      
      assert u.admin?
    end
    
    test "should successfully login for the first time and create a new user" do
      assert_difference 'User.count' do
        User.login 'newuser.myopenid.com', attributes
      end
    end
    
    test "should create a setting the first time a user logs in" do
      assert_difference 'Setting.count' do
        u = User.login new_user.identity_url, attributes
        assert_kind_of Setting, u.setting
      end
    end
      
    test "should not create a setting each time a user logs in" do
      u = create_user
    
      assert_no_difference 'Setting.count' do
        User.login u.identity_url, attributes
      end
    end
      
    test "should successfully login and update the user's sreg info" do
      u = create_user
    
      updated_sreg = {
        'nickname' => 'rph',
        'email' => 'ryan@portfolio.rpheath.com'
      }
    
      assert_no_difference 'User.count' do
        updated_user = User.login u.identity_url, updated_sreg
    
        assert_equal 'rph', updated_user.nickname
        assert_equal 'ryan@portfolio.rpheath.com', updated_user.email
      end
    end
      
    test "name should be titleized" do
      u = new_user(:nickname => nil, :fullname => 'ryan heath')
      assert_not_equal 'ryan heath', u.name
      assert_equal 'Ryan Heath', u.name
    end
      
    test "should return a OpenStruct collection of defaults" do
      require 'ostruct'
    
      u = User.login new_user.identity_url, attributes
      assert_kind_of OpenStruct, u.defaults
    end
      
    test "should own a given object" do
      setting = Setting.new(:user_id => users(:ryan).id)
      assert users(:ryan).owns?(setting)
    end
end