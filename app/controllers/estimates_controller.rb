class EstimatesController < ApplicationController
  def index
    render
  end
  
  def new
    @estimate = Estimate.new
    3.times { @estimate.tasks.build }
  end
  
  def create
    @estimate = Estimate.new(params[:estimate])
    @estimate.save!
    notice "Successfully created an estimate for: #{@estimate.title}"
    redirect_to estimates_path
  rescue ActiveRecord::RecordInvalid
    error "Invalid estimate"
    render :action => 'new'
  end
end