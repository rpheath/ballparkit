class Estimate < ActiveRecord::Base
  has_many :tasks, :attributes => true,
    :discard_if => proc { |task|
      task.description.blank? && task.hours.blank? && task.rate.blank?
    }, :dependent => :destroy
  belongs_to :user
  
  named_scope :descending, :order => 'id DESC'
  
  validates_presence_of :title
  
  def self.paginated(user, page, options = {})
    descending.paginate(:all, :conditions => { 
        :user_id => user.id 
      }, :page => page, :per_page => options[:per_page] || 10)
  end
  
  def total(type)
    tasks.inject(0) do |sum, task|
      sum += case type
      when :price then task.rate.to_i * task.hours.to_i 
      when :hours then task.hours.to_i 
      else 0 end
    end.to_s
  end
end