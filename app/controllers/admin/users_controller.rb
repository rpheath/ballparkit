class Admin::UsersController < Admin::BaseController
  def index
    @users = User.paginated(params[:page], :per_page => 25)
  end
  
  def destroy
    user = User.find(params[:id])
    name = user.name
    user.destroy
    notice "#{name} was successfully deleted"
    redirect_to admin_users_path
  end
end