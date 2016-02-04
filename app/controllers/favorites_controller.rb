class FavoritesController < UserBaseController
  def index
    prepare_rendering_favorite_index
  end

  def create
    fav_params = params.permit(:comment_id)
    fav_params[:user_id] = current_user.id
    @favorite = Favorite.new(fav_params)
    if @favorite.save
      if params[:render_to] == 'comments/index'
        prepare_rendering_comment_index
        render params[:render_to]
        return
      end
      render params[:render_to]
    else
      flash[:alert] = 'Failed to favorite this comment.'
      render params[:render_to]
    end
  end

  def destroy
    favorite = Favorite.find(params[:id])
    if current_user.id == favorite.user_id
      if params[:render_to] == 'comments/index'
        if favorite.destroy
          prepare_rendering_comment_index
          render params[:render_to]
        else
          prepare_rendering_comment_index
          render params[:render_to]
        end
      else
        if favorite.destroy
          prepare_rendering_favorite_index
          render params[:render_to]
        else
          prepare_rendering_favorite_index
          render params[:render_to]
        end
      end
    else
      if params[:render_to] == 'comments/index'
        prepare_rendering_comment_index
        render params[:render_to]
      else
        prepare_rendering_favorite_index
        render params[:render_to]
      end
    end
  end

  private
    def prepare_rendering_comment_index
      @comments = Comment.where(my_thread_id: params[:thread_id]).includes(:user, :my_thread, :favorite)
      @thread_name = MyThread.find(params[:thread_id]).title
      @comment = Comment.new
    end

    def prepare_rendering_favorite_index
      favorite_comment_ids = Favorite.where(user_id: params[:user_id]).pluck(:comment_id)
      @favorites = Comment.where(id: favorite_comment_ids).includes(:my_thread, :favorite, :user)
      @user_name = User.find(params[:user_id]).name
    end
end
