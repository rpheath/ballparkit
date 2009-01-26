class Task < ActiveRecord::Base
  belongs_to :estimate
  belongs_to :user
  
  after_save :set_defaults
  
  attr_accessor :default
  
  def total
    hours.to_f * rate.to_f
  end
  
private
  def set_defaults
    task_exists = DefaultTask.found?(user.setting.id, description)

    if default.to_i == 1 && !task_exists
      DefaultTask.create(:setting_id => user.setting.id, :description => description)
    elsif default.to_i == 0 && task_exists
      DefaultTask.first(:conditions => {
        :setting_id => user.setting.id, :description => description }).destroy
    end
  end
end