class User < ActiveRecord::Base
  validates_presence_of :identity_url, :fullname, :email
  validates_uniqueness_of :identity_url
  
  before_save :normalize_url
  
private
  def normalize_url
    self[:identity_url] = OpenIdAuthentication.normalize_url(self[:identity_url])
  end
  
  def self.update_from_sreg!(identity_url, sreg)
    user = find_by_identity_url(identity_url)
    user.update_attributes!(
      :nickname => sreg['nickname'],
      :fullname => sreg['fullname'],
      :email => sreg['email']
    )
    user
  rescue ActiveRecord::RecordInvalid
    []
  end

  def self.create_from_sreg!(identity_url, sreg)
    user = self.create!(
      :identity_url => identity_url,
      :nickname => sreg['nickname'],
      :fullname => sreg['fullname'],
      :email => sreg['email']
    )

    user
  rescue ActiveRecord::RecordInvalid
    []
  end

public  
  def self.login(identity_url, registration)
    if exists?(:identity_url => identity_url)
      update_from_sreg!(identity_url, registration)
    else
      create_from_sreg!(identity_url, registration)
    end
  end
  
  def name
    fullname.titleize
  end
end