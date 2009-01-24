class Estimate < ActiveRecord::Base
  has_many :tasks, :attributes => true
  
  validates_presence_of :title
  
  def total
    tasks.inject(0) do |sum, task|
      sum += task.rate.to_i * task.hours.to_i
    end.to_s
  end
end