class SettingsController < ApplicationController
  def index
    @setting = current_user.setting
  end
  
  def edit
    @setting = Setting.find(params[:id])
  end
  
  def update
    @setting = Setting.find(params[:id])
    @setting.update_attributes!(params[:setting])
    notice "Your settings were successfully updated"
    redirect_to settings_path
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end
end