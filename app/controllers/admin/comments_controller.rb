class Admin::CommentsController < Admin::BaseController
  def index
    @comments = Comment.where(my_thread_id: params[:thread_id]).includes(:user, :my_thread, :favorite)
    @thread_name = MyThread.find(params[:thread_id]).title
    @comment = Comment.new
  end

  def destroy
    if Comment.find(params[:id]).destroy
      redirect_to admin_thread_comments_url(thread_id: params[:thread_id]), notice: 'Successfully deleted a thread.'
    else
      redirect_to admin_thread_comments_url(thread_id: params[:thread_id]), alert: 'Failed to delete a thread.'
    end
  end
end
