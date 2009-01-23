class Estimate < ActiveRecord::Base
  has_many :tasks
  associated_save :tasks
  
  validates_presence_of :title
end