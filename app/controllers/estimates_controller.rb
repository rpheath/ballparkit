class EstimatesController < ApplicationController
  def index
    @estimates = current_user.estimates
  end
  
  def new
    @estimate = Estimate.new
    10.times { @estimate.tasks.build }
  end
  
  def create
    @estimate = Estimate.new(params[:estimate])
    @estimate.save!
    notice "Successfully created an estimate for: #{@estimate.title}"
    redirect_to estimates_path
  rescue ActiveRecord::RecordInvalid
    @estimate.tasks.build params[:estimate][:_tasks]
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