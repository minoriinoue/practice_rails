class UsersController < UserBaseController
  def show
    @user = User.find(params[:id])
    if current_user.id == params[:id].to_i
      @message = 'Profile'
    else
      @follow = Follow.find_by(follower_id: current_user.id, followee_id: params[:id])
    end
  end

  def upload_photo
    @user = User.find(params[:id])
    @user.avatar = params[:user][:file_name]
    @user.save
    render :show
  end
end
