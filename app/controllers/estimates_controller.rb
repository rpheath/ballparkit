class EstimatesController < ApplicationController
  skip_before_filter :login_required, :only => :by_token
  before_filter :get_estimate, :except => [:index, :by_token]
  
  def index
    @estimates = Estimate.paginated(current_user, params[:page], :per_page => 15)
  end
  
  def show
  end
  
  def by_token
    @estimate = Estimate.find_by_token!(params[:token])
    render :layout => 'public'
  rescue Ballpark::InvalidToken => e
    warning e.message
    redirect_to estimates_path
  end
  
  def new
    if current_user.defaults.tasks.blank?
      @estimate.tasks.build
    else
      current_user.defaults.tasks.each do |task|
        @estimate.tasks.build :description => task
      end
    end
  end
  
  def create
    @estimate = Estimate.new(params[:estimate])
    @estimate.save!
    Ballpark::UrlShortener.new(@estimate, request.host_with_port).process
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
    ensure_permission!(@estimate)
  end
end