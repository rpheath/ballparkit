class EstimatesController < ApplicationController
  def index
    @estimates = Estimate.paginated(current_user, params[:page])
  end
  
  def new
    @estimate = Estimate.new
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
    @estimate = Estimate.find(params[:id])
  end
  
  def update
    @estimate = Estimate.find(params[:id])
    @estimate.update_attributes!(params[:estimate])
    notice "Successfully updated #{@estimate.title}"
    redirect_to estimates_path
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end
  
  def destroy
    @estimate = Estimate.find(params[:id])
    title = @estimate.title
    @estimate.destroy
    notice "Successfully deleted your #{title} estimate"
    redirect_to estimates_path
  end
end