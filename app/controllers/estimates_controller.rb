class EstimatesController < ApplicationController
  before_filter :get_estimate, :except => [:index]
  
  def index
    @estimates = Estimate.paginated(current_user, params[:page])
  end
  
  def show
  end
  
  def new
    if current_user.defaults.tasks.blank?
      5.times { @estimate.tasks.build }
    else
      current_user.defaults.tasks.map(&:description).each do |task|
        @estimate.tasks.build :description => task
      end
    end
  end
  
  def create
    @estimate = Estimate.new(params[:estimate])
    @estimate.save!
    notice "Successfully created an estimate for: #{@estimate.title}"
    redirect_to estimates_path
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
  
  def edit
  end
  
  def update
    @estimate.update_attributes!(params[:estimate])
    notice "Successfully updated #{@estimate.title}"
    redirect_to estimates_path
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end
  
  def destroy
    title = @estimate.title
    @estimate.destroy
    notice "Successfully deleted your #{title} estimate"
    redirect_to estimates_path
  end

private
  def get_estimate
    @estimate = params[:id] ? Estimate.find(params[:id]) : Estimate.new
  end
end