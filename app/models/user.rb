require 'ostruct'

class User < ActiveRecord::Base
  has_many :estimates
  has_many :tasks, :dependent => :destroy
  has_one :setting
  
  validates_presence_of :identity_url, :nickname, :email
  validates_uniqueness_of :identity_url
  
  before_save :normalize_url
  
  def self.login(identity_url, registration)
    if exists?(:identity_url => normalize_url(identity_url))
      update_from_sreg!(identity_url, registration)
    else
      create_from_sreg!(identity_url, registration)
    end
  end
  
  def name
    fullname.blank? ? nickname : fullname.titleize
  end
  
  def defaults
    OpenStruct.new(:rate => setting.default_rate, 
      :tasks => setting.default_tasks.map(&:description))
  end
  
  def owns?(obj)
    obj.user_id == id
  end
  
private
  def normalize_url
    self[:identity_url] = self.class.normalize_url(self[:identity_url])
  end
  
  def self.normalize_url(identifier)
    OpenIdAuthentication.normalize_identifier(identifier)
  end
  
  def self.update_from_sreg!(identity_url, sreg)
    user = find_by_identity_url(normalize_url(identity_url))
    user.update_attributes!(
      :nickname => sreg['nickname'],
      :fullname => sreg['fullname'],
      :email => sreg['email']
    )
    user
  end

  def self.create_from_sreg!(identity_url, sreg)
    user = self.create!(
      :identity_url => identity_url,
      :nickname => sreg['nickname'],
      :fullname => sreg['fullname'],
      :email => sreg['email']
    )
    Setting.create!(:user_id => user.id)
    
    user
  end
end