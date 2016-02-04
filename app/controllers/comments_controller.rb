class CommentsController < UserBaseController
  def index
    success_view
  end

  def create
    comment_params = params.require(:comment).permit(:comment, :my_thread_id)
    comment_params[:user_id] = current_user.id
    @comment = Comment.new(comment_params)
    if @comment.save
      success_view
      render :index
    else
      # Since a comment does not want to be a new one when fail to make a comment,
      # use fetch_comments_and_thread_name instead of fail_view, which call
      # @comment = Comment.new
      fetch_comments_and_thread_name
      render :index
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if current_user.id == comment.user_id
      if comment.destroy
        success_view
        render :index
      else
        fail_view('Failed to delete a thread.')
        render :index
      end
    else
      fail_view('You are not allowed to delete this comment.')
      render :index
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    comment_params = params.require(:comment).permit(:my_thread_id, :id, :comment)
    @comment = Comment.find(comment_params[:id])
    if !comment_params[:comment].empty?
      @comment.comment = comment_params[:comment]
      if @comment.comment == params[:comment][:original_comment]
        redirect_to edit_thread_comment_url,
          thread_id: params[:my_thread_id],
          id: params[:id],
          alert: 'Comment remained same'
        return
      end
    else
      redirect_to edit_thread_comment_url,
        thread_id: params[:my_thread_id],
        id: params[:id],
        alert: 'Comment cannot be empty'
    end

    if @comment.save
      flash[:notice] = 'Successfully updated.'
      render :edit
    else
      flash[:alert] = 'Failed to update.'
      render :edit
    end
  end

  private
  def fetch_comments_and_thread_name
    @comments = Comment.where(my_thread_id: params[:thread_id]).includes(:user, :my_thread, :favorite)
    @thread_name = MyThread.find(params[:thread_id]).title
  end

  def success_view
    fetch_comments_and_thread_name
    @comment = Comment.new
  end

  def fail_view(fail_message)
    fetch_comments_and_thread_name
    flash[:alert] = fail_message
  end
end
