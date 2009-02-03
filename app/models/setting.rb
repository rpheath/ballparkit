class Setting < ActiveRecord::Base
  belongs_to :user
  has_many :default_tasks, :attributes => true,
    :discard_if => proc { |task| task.description.blank? }
  
  attr_accessor :clear_all
  
  after_save :clear_default_tasks?
  
  def default_rate
    read_attribute(:default_rate).to_s.gsub(/^\$/, '')
  end

private
  def clear_default_tasks?
    default_tasks.each { |task| task.destroy } if clear_all.to_i == 1
  end
end