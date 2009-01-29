module EstimatesHelper
  def default_rate
    return unless @estimate.new_record? && current_user.setting.use_default_rate?
    number_to_currency(current_user.setting.default_rate).gsub(/^\$/, '')
  end
end