class FollowsController < UserBaseController
  def index
    if params[:status] == 'followed'
      @page_title = 'Followers'
      follower_ids = Follow.where(followee_id: params[:user_id]).pluck(:follower_id)
      @users = User.where(id: follower_ids)
    else
      @page_title = 'Following'
      following_ids = Follow.where(follower_id: params[:user_id]).pluck(:followee_id)
      @users = User.where(id: following_ids)
    end
  end

  def create
    follow_params = params.permit(:follower_id, :followee_id)
    @follow = Follow.new(follow_params)
    if @follow.save
      fetch_user_and_followings
      render 'users/show'
    else
      fetch_user_and_followings
      flash[:alert] = 'Failed to follow this user.'
      render 'users/show'
    end
  end

  def destroy
    if current_user.id == Follow.find(params[:id]).follower_id
      if Follow.find(params[:id]).destroy
        @user = User.find(params[:followee_id])
        render 'users/show'
      else
        fetch_user_and_followings
        flash[:alert] = 'Failed to unfollow this user.'
        render 'users/show'
      end
    else
      fetch_user_and_followings
      flash[:alert] = 'Failed to unfollow this user.'
      render 'users/show'
    end
  end

  private
  # This function is used only when the user wants to follow/unfollow a user.
  # Thus, follower_id is always the id of current_user. This method id used
  # in create and destroy.
  def fetch_user_and_followings
    @user = User.find(params[:followee_id])
    @follow = Follow.find_by(follower_id: current_user.id, followee_id: params[:followee_id])
  end
end
