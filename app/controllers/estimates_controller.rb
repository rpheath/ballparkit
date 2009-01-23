class EstimatesController < ApplicationController
  def index
    render
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
end