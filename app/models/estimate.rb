require 'digest/sha1'

module Ballpark
  class InvalidToken < Error
    message "Sorry, couldn't find estimate by that token"
  end
end

class Estimate < ActiveRecord::Base
  has_many :tasks, :attributes => true,
    :discard_if => proc { |task|
      task.description.blank? && task.hours.blank? && task.rate.blank?
    }, :dependent => :destroy do
    def clone!
      self.inject([]) { |tasks, t| tasks << t.clone! }
    end
  end
  belongs_to :user
  
  named_scope :descending, :order => 'id DESC'
  
  validates_presence_of :title
  
  after_create :tokenize
  
  def self.paginated(user, page, options = {})
    descending.paginate(:all, :conditions => { 
        :user_id => user.id 
      }, :page => page, :per_page => options[:per_page] || per_page)
  end
  
  def self.find_by_token!(token)
    find_by_token(token) or raise Ballpark::InvalidToken
  end
  
  def total_price
    total(:price, :apply_discount => true)
  end
  
  def sub_total
    total(:price, :apply_discount => false)
  end
  
  def total_hours
    total(:hours)
  end
  
  def savings
    return 0 unless has_discount?
    (discount.to_f / 100) * total(:price, :discount => false).to_f
  end
  
  def clone!
    e = self.class.create(:title => "Copy of #{self.title}")
    e.tasks << self.tasks.clone!
    e.reload
  end
  
  def has_discount?
    !discount.blank?
  end
  
private
  def total(type, options = {})
    tot = tasks.inject(0) do |sum, task|
      sum += case type
      when :price then task.rate.to_f * task.hours.to_f 
      when :hours then task.hours.to_f 
      else 0 end
    end.to_s 
    
    return tot if type == :hours
    
    (options[:apply_discount] ? tot.to_f - savings : tot).to_s
  end
  
  def self.secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end
  
  def tokenize
    self[:token] = self.class.secure_digest(self[:id], self[:created_at], (1..10).map { rand.to_s })
    save(false)
  end
end