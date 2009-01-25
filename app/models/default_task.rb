class DefaultTask < ActiveRecord::Base
  belongs_to :setting
  
  def self.found?(setting_id, description)
    exists?(:setting_id => setting_id, :description => description)
  end
end
