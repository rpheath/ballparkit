class SettingsController < ApplicationController
  before_filter :get_setting, :except => [:index]
  
  def index
    @setting = current_user.setting
  end
  
  def edit
  end
  
  def update
    @setting.update_attributes!(params[:setting])
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