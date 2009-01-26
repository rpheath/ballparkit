require 'ostruct'

class Setting < ActiveRecord::Base
  belongs_to :user
  has_many :default_tasks, :attributes => true,
    :discard_if => proc { |task| task.description.blank? }
  
  def self.support
    OpenStruct.new(
      :default_rate => 'Default Rate support',
      :use_default_rate => 'Using Default Rate support',
      :tasks => 'Tasks support'
    )
  end
end