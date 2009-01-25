module EstimatesHelper
  def default_rate
    return unless @estimate.new_record? && current_user.setting.use_default_rate?
    current_user.setting.default_rate
  end
end