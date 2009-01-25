class Setting < ActiveRecord::Base
  belongs_to :user
  has_many :default_tasks
end