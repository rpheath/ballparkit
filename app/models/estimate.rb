class Estimate < ActiveRecord::Base
  has_many :tasks
  associated_save :tasks
end