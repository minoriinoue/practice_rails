class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @followee_number = Follow.where(followee_id: params[:id]).count
    @following_number = Follow.where(follower_id: params[:id]).count
  end

  def destroy
    if User.find(params[:id]).destroy
      Follow.where(followee_id: params[:id]).destroy_all
      Follow.where(follower_id: params[:id]).destroy_all
      redirect_to admin_users_url, notice: 'Succeeded in deleting a user.'
    else
      redirect_to admin_users_url, notice: 'Failed to delete a user.'
    end
  end
end
