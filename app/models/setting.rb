class Setting < ActiveRecord::Base
  belongs_to :user
  has_many :default_tasks, :attributes => true,
    :discard_if => proc { |task| task.description.blank? }
end