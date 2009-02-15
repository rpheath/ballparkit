class SettingsController < ApplicationController
  before_filter :get_setting, :except => [:index]
  
  def index
    @setting = current_user.setting
    @tasks   = current_user.defaults.tasks
  end
  
  def edit
  end
  
  def update
    @setting.update_attributes!(params[:setting])
    current_user.update_attribute(:time_zone, params[:time_zone]) if params[:time_zone]
    notice "Your settings were successfully updated"
    redirect_to settings_path
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end
  
protected
  def get_setting
    @setting = Setting.find(params[:id])
    ensure_permission!(@setting)
  end
end